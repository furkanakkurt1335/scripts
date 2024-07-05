import qrcode, argparse

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--text', help='Text to encode in QR code', required=True)
    return parser.parse_args()

def main():
    args = get_args()
    img = qrcode.make(args.text)
    img.save('qr.png')

if __name__ == '__main__':
    main()