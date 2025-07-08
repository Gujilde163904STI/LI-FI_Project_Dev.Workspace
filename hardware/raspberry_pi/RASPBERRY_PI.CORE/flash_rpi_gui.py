#!/usr/bin/env python3
"""
GUI tool to flash Raspberry Pi images to SD cards using dd or rpi-imager.
- Lists available removable devices
- Lets user select image and device
- Shows flashing progress
"""
import os
import sys
import glob
import platform
import subprocess
import threading
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

def list_removable_devices():
    if platform.system() == 'Darwin':
        devices = glob.glob('/dev/disk*')
        return [d for d in devices if 'disk' in d and not d.endswith('s1')]
    elif platform.system() == 'Linux':
        devices = glob.glob('/dev/sd*')
        return [d for d in devices if d[-1].isdigit() is False]
    else:
        return []

def flash_image(image, device, progress_callback, done_callback):
    def run():
        try:
            if platform.system() == 'Darwin':
                subprocess.run(['diskutil', 'unmountDisk', device], check=True)
            if shutil.which('rpi-imager'):
                cmd = ['rpi-imager', '--cli', '--image', image, '--target', device]
                proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            else:
                cmd = ['sudo', 'dd', f'if={image}', f'of={device}', 'bs=4m', 'status=progress']
                proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            for line in iter(proc.stdout.readline, b''):
                progress_callback(line.decode(errors='ignore'))
            proc.wait()
            done_callback('Flashing complete!')
        except Exception as e:
            done_callback(f'Error: {e}')
    threading.Thread(target=run).start()

class FlashGUI(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('Raspberry Pi Imager GUI')
        self.geometry('500x350')
        self.devices = list_removable_devices()
        self.selected_device = tk.StringVar()
        self.selected_image = tk.StringVar()
        self.create_widgets()

    def create_widgets(self):
        tk.Label(self, text='Select Device:').pack(pady=5)
        self.device_combo = ttk.Combobox(self, values=self.devices, textvariable=self.selected_device)
        self.device_combo.pack(fill='x', padx=10)
        tk.Label(self, text='Select Image:').pack(pady=5)
        frame = tk.Frame(self)
        frame.pack(fill='x', padx=10)
        tk.Entry(frame, textvariable=self.selected_image, width=40).pack(side='left', expand=True, fill='x')
        tk.Button(frame, text='Browse', command=self.browse_image).pack(side='left', padx=5)
        tk.Button(self, text='Flash', command=self.start_flash).pack(pady=15)
        self.progress = tk.Text(self, height=10, state='disabled')
        self.progress.pack(fill='both', padx=10, pady=5, expand=True)

    def browse_image(self):
        img = filedialog.askopenfilename(filetypes=[('Image Files', '*.img *.iso *.zip'), ('All Files', '*.*')])
        if img:
            self.selected_image.set(img)

    def start_flash(self):
        device = self.selected_device.get()
        image = self.selected_image.get()
        if not device or not image:
            messagebox.showerror('Error', 'Please select both device and image.')
            return
        self.progress.config(state='normal')
        self.progress.delete('1.0', tk.END)
        self.progress.insert(tk.END, f'Flashing {image} to {device}...\n')
        self.progress.config(state='disabled')
        flash_image(image, device, self.update_progress, self.flash_done)

    def update_progress(self, text):
        self.progress.config(state='normal')
        self.progress.insert(tk.END, text)
        self.progress.see(tk.END)
        self.progress.config(state='disabled')

    def flash_done(self, msg):
        self.progress.config(state='normal')
        self.progress.insert(tk.END, f'\n{msg}\n')
        self.progress.config(state='disabled')
        messagebox.showinfo('Done', msg)

if __name__ == '__main__':
    import shutil
    app = FlashGUI()
    app.mainloop()

