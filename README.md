# 🧠 Lithography Tool Control Dashboard (ASML-Inspired)

## 🚀 Overview

This project is a simulated **lithography scanner control system interface**, inspired by semiconductor fabrication tools such as ASML steppers/scanners.

It provides a real-time operator dashboard for:

* Wafer exposure monitoring
* Process state control
* Scanner parameter visualization
* Alarm and interlock handling

---

## 🏭 System Features

### 🧪 Wafer Exposure Map

* Visual representation of wafer die grid
* Real-time exposure progress (%)
* Pass / fail indicators per die

### ⚙️ Process Flow Simulation

* Batch Queue → Load → Align → Expose → Inspect → Complete
* Timer-based process transitions
* Operator-triggered actions (Start / Stop Exposure)

### 🧷 Safety Interlocks

* Vacuum stability
* Wafer presence
* Reticle lock
* Door closed status

System prevents exposure if any condition fails.

---

## 📊 Scanner Parameters Panel

Displays simulated tool data:

* Dose (mJ/cm²)
* Focus offset (µm)
* Overlay error (nm)
* Tool status and readiness

---

## 🚨 Alarm & Event System

* Real-time alarm messages
* Event logging (INFO / WARNING / CRITICAL)
* Operator acknowledgment (ACK)

---

## 🖥️ Tech Stack

* Qt (QML + C++)
* Python (backend simulation)
* Git / GitHub (version control)

---

## 🔌 Future Improvements

* Real machine integration (SECS/GEM, OPC-UA, REST APIs)
* Live sensor data streaming
* Predictive maintenance alerts
* Multi-tool dashboard view

---

## 📸 Screenshots

*(Add your UI screenshots here)*

---

## 🧠 Author

Built by someone focused on bridging:
**software + semiconductor manufacturing systems**
