import sys
from datetime import datetime, timedelta

def generate_nudge_schedule(target_time_str):
    try:
        target_time = datetime.strptime(target_time_str, "%H:%M")
    except ValueError:
        print("Error: Invalid time format. Use HH:MM (e.g., 08:30)")
        sys.exit(1)

    # 3-step notification cycle
    soft_nudge = target_time + timedelta(minutes=5)
    medium_nudge = target_time + timedelta(minutes=15)
    critical_alert = target_time + timedelta(minutes=30)

    print(f"--- Nudge Schedule for {target_time_str} ---")
    print(f"Soft Nudge:    {soft_nudge.strftime('%H:%M')} (+5 min)")
    print(f"Medium Nudge:  {medium_nudge.strftime('%H:%M')} (+15 min)")
    print(f"CRITICAL Alert: {critical_alert.strftime('%H:%M')} (+30 min)")
    print("--------------------------------")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python nudge_engine.py [HH:MM]")
        sys.exit(1)
    
    generate_nudge_schedule(sys.argv[1])
