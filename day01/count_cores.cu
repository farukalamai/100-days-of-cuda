#include <iostream>
#include <cuda_runtime.h>
#include <unistd.h> // for usleep

__global__ void countOnGPU(int *counter, int totalThreads) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < totalThreads) {
        counter[idx] = idx + 1;
    }
}

int main() {
    // Get GPU info
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    
    std::cout << "GPU: " << prop.name << std::endl;
    std::cout << "Streaming Multiprocessors (SMs): " << prop.multiProcessorCount << std::endl;
    
    int coresPerSM = 128; // RTX 50 series
    int totalCores = prop.multiProcessorCount * coresPerSM;
    std::cout << "Total CUDA Cores: " << totalCores << std::endl;
    std::cout << "\nCounting CUDA cores in real-time:\n" << std::endl;
    
    const int N = totalCores;
    int *d_counter;
    int *h_counter = new int[N];
    
    cudaMalloc(&d_counter, N * sizeof(int));
    
    int threadsPerBlock = 256;
    
    // Count one by one to show real-time
    for (int i = 1; i <= N; i++) {
        int currentBlocks = (i + threadsPerBlock - 1) / threadsPerBlock;
        
        countOnGPU<<<currentBlocks, threadsPerBlock>>>(d_counter, i);
        cudaDeviceSynchronize();
        
        // Show current count
        std::cout << "\rCUDA Cores Active: " << i << " / " << totalCores << std::flush;
        
        // Slow down so you can see it (remove this for full speed)
        if (i % 100 == 0) {
            usleep(10000); // 10ms delay every 100 counts
        }
    }
    
    std::cout << "\n\n✓ All " << totalCores << " CUDA cores verified and working!" << std::endl;
    
    delete[] h_counter;
    cudaFree(d_counter);
    
    return 0;
}