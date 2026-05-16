import serial

baudrates = [9600,19200,38400,57600,115200,230400,460800,921600,1500000]

for b in baudrates:
    try:
        ser = serial.Serial('/dev/ttyUSB0', b, timeout=1)
        data = ser.read(200)
        printable = sum(32 <= c < 127 for c in data)
        print(b, printable)
        ser.close()
    except:
        pass
