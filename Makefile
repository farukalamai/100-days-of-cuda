# Root Makefile for 100 Days of CUDA

# Compiler settings
NVCC = nvcc
ARCH = sm_89
FLAGS = -arch=$(ARCH) -Wno-deprecated-gpu-targets

# Find all day directories
DAY_DIRS = $(wildcard day*)

# Colors for output
GREEN = \033[0;32m
NC = \033[0m # No Color

.PHONY: all clean clean-all help list

# Default target
all:
	@echo "Use 'make clean' to remove all executables"
	@echo "Use 'make list' to see all day folders"
	@echo "Use 'make help' for more options"

# Clean all executables from all day folders
clean:
	@echo "$(GREEN)Cleaning executables from all day folders...$(NC)"
	@find day* -type f -executable ! -name "*.sh" ! -name "*.cu" -delete 2>/dev/null || true
	@find day* -type f ! -name "*.*" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ All executables cleaned!$(NC)"

# More aggressive clean (includes object files, etc.)
clean-all: clean
	@echo "$(GREEN)Cleaning all build artifacts...$(NC)"
	@find . -name "*.o" -delete 2>/dev/null || true
	@find . -name "*.out" -delete 2>/dev/null || true
	@find . -name "*.exe" -delete 2>/dev/null || true
	@find . -name "*.ptx" -delete 2>/dev/null || true
	@find . -name "*.cubin" -delete 2>/dev/null || true
	@find . -name "*.fatbin" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ All build artifacts cleaned!$(NC)"

# List all day directories and their contents
list:
	@echo "$(GREEN)Day folders:$(NC)"
	@for dir in $(DAY_DIRS); do \
		echo "\n$$dir:"; \
		ls -lh $$dir 2>/dev/null || echo "  (empty)"; \
	done

# Show what would be cleaned (dry run)
dry-run:
	@echo "$(GREEN)Executables that would be removed:$(NC)"
	@find day* -type f -executable ! -name "*.sh" ! -name "*.cu" 2>/dev/null || echo "None found"
	@find day* -type f ! -name "*.*" 2>/dev/null || echo "None found"

# Help message
help:
	@echo "100 Days of CUDA - Makefile Commands:"
	@echo ""
	@echo "  make clean      - Remove all executables from day folders"
	@echo "  make clean-all  - Remove executables + build artifacts (.o, .out, etc.)"
	@echo "  make list       - List all day folders and their contents"
	@echo "  make dry-run    - Show what would be cleaned (without deleting)"
	@echo "  make help       - Show this help message"
	@echo ""
	@echo "Quick workflow before Git push:"
	@echo "  make clean && git add . && git commit -m 'message' && git push"