#!/usr/bin/env python3

import sys
import pandas as pd
import numpy as np
import time
import psutil
import platform
import cpuinfo
from numba import jit

def print_decorated_hello_world():
    print("\n" + "=" * 60)
    print("*" * 20 + " Hello, World! " + "*" * 20)
    print("Welcome to the Python Environment Test Script")
    print("=" * 60 + "\n")

def get_size(bytes, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"
        bytes /= factor

def get_system_info():
    print("="*40, "System Information", "="*40)
    uname = platform.uname()
    print(f"System: {uname.system}")
    print(f"Node Name: {uname.node}")
    print(f"Release: {uname.release}")
    print(f"Version: {uname.version}")
    print(f"Machine: {uname.machine}")
    print(f"Processor: {uname.processor}")
    
    # CPU information
    print("="*40, "CPU Info", "="*40)
    print("Physical cores:", psutil.cpu_count(logical=False))
    print("Total cores:", psutil.cpu_count(logical=True))
    
    # CPU frequencies
    cpufreq = psutil.cpu_freq()
    print(f"Max Frequency: {cpufreq.max:.2f}Mhz")
    print(f"Min Frequency: {cpufreq.min:.2f}Mhz")
    print(f"Current Frequency: {cpufreq.current:.2f}Mhz")
    
    # CPU usage
    print("CPU Usage Per Core:")
    for i, percentage in enumerate(psutil.cpu_percent(percpu=True, interval=1)):
        print(f"Core {i}: {percentage}%")
    print(f"Total CPU Usage: {psutil.cpu_percent()}%")
    
    # Memory Information
    print("="*40, "Memory Information", "="*40)
    svmem = psutil.virtual_memory()
    print(f"Total: {get_size(svmem.total)}")
    print(f"Available: {get_size(svmem.available)}")
    print(f"Used: {get_size(svmem.used)}")
    print(f"Percentage: {svmem.percent}%")
    
    # Disk Information
    print("="*40, "Disk Information", "="*40)
    partitions = psutil.disk_partitions()
    for partition in partitions:
        print(f"=== Device: {partition.device} ===")
        print(f"  Mountpoint: {partition.mountpoint}")
        print(f"  File system type: {partition.fstype}")
        try:
            partition_usage = psutil.disk_usage(partition.mountpoint)
        except PermissionError:
            continue
        print(f"  Total Size: {get_size(partition_usage.total)}")
        print(f"  Used: {get_size(partition_usage.used)}")
        print(f"  Free: {get_size(partition_usage.free)}")
        print(f"  Percentage: {partition_usage.percent}%")

@jit(nopython=True)
def estimate_pi(n):
    points_inside_circle = 0
    total_points = n
    for _ in range(total_points):
        x = np.random.uniform(-1, 1)
        y = np.random.uniform(-1, 1)
        if x*x + y*y <= 1:
            points_inside_circle += 1
    pi_estimate = 4 * points_inside_circle / total_points
    return pi_estimate

def test_environment():
    print_decorated_hello_world()  # Add this line at the beginning of the function
    print(f"Python version: {sys.version}")
    print(f"Pandas version: {pd.__version__}")
    print(f"NumPy version: {np.__version__}")
    
    # Test pandas
    print("\nPandas Tests:")
    df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C': ['a', 'b', 'c']})
    print("DataFrame:")
    print(df)
    
    print("\nDataFrame info:")
    df.info()
    
    print("\nDataFrame description:")
    print(df.describe())
    
    print("\nGroupby operation:")
    print(df.groupby('C').sum())

    # Test numpy
    print("\nNumPy Tests:")
    arr = np.array([1, 2, 3, 4, 5])
    print("1D array:")
    print(arr)
    print(f"Array mean: {arr.mean()}")
    print(f"Array sum: {arr.sum()}")
    print(f"Array standard deviation: {arr.std()}")

    print("\n2D array:")
    arr_2d = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    print(arr_2d)
    print(f"Shape: {arr_2d.shape}")
    print(f"Sum of all elements: {arr_2d.sum()}")
    print(f"Sum along rows: {arr_2d.sum(axis=1)}")
    print(f"Sum along columns: {arr_2d.sum(axis=0)}")

    print("\nNumPy operations:")
    print(f"Matrix multiplication:\n{np.dot(arr_2d, arr_2d)}")

    # Pi estimation
    print("\nPi Estimation Test:")
    start_time = time.time()
    pi_estimate = estimate_pi(10000000)
    end_time = time.time()
    
    print(f"Estimated value of pi: {pi_estimate}")
    print(f"Actual value of pi: {np.pi}")
    print(f"Difference: {abs(pi_estimate - np.pi)}")
    print(f"Time taken: {end_time - start_time:.2f} seconds")

if __name__ == "__main__":
    get_system_info()
    test_environment()
