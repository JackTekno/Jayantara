from fastapi import FastAPI, HTTPException
from pydantic import BaseModel # type: ignore
from subprocess import run, PIPE
import re
import datetime
import os
import json

app = FastAPI()

class ScanRequest(BaseModel):
    target: str
    options: str

def parse_nmap_output(output: str):
    result = {
        "ip": None,
        "status": None,
        "ports": [],
        "timestamp": datetime.datetime.now().isoformat()
    }

    ip_match = re.search(r"Nmap scan report for (.+?) \(([\d.]+)\)", output)
    if ip_match:
        result["host"] = ip_match.group(1)
        result["ip"] = ip_match.group(2)
    else:
        result["host"] = None
        result["ip"] = None

    status_match = re.search(r"Host is (\w+)", output)
    result["status"] = status_match.group(1) if status_match else "unknown"

    for line in output.splitlines():
        port_match = re.match(r"(\d+)/tcp\s+(\w+)\s+(\S+)\s*(.*)", line)
        if port_match:
            result["ports"].append({
                "port": int(port_match.group(1)),
                "protocol": "tcp",
                "state": port_match.group(2),
                "service": port_match.group(3),
                "version": port_match.group(4).strip() if port_match.group(4) else "-"
            })

    return result

def save_log(scan_result: dict):
    log_dir = "logs"
    os.makedirs(log_dir, exist_ok=True)

    timestamp = scan_result.get("timestamp", datetime.datetime.now().isoformat())
    safe_time = timestamp.replace(":", "-")
    filename = f"{log_dir}/scanlog-{safe_time}.json"

    with open(filename, "w") as f:
        json.dump(scan_result, f, indent=2)

@app.get("/")
def read_root():
    return {"message": "Jayantara Scanner Backend is running!"}

@app.post("/scan")
def scan_target(request: ScanRequest):
    try:
        command = ["nmap"] + request.options.split() + [request.target]
        result = run(command, stdout=PIPE, stderr=PIPE, text=True)

        if result.returncode != 0:
            raise HTTPException(status_code=500, detail="Nmap execution failed")

        parsed = parse_nmap_output(result.stdout)
        parsed["target"] = request.target

        save_log(parsed)  # Simpan hasil scan ke file

        return parsed

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
