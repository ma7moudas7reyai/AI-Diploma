# Take input from user
rows = int(input("Enter number of rows (>=3): "))
cols = int(input("Enter number of columns (>=3): "))

# Calculate center
center_row = rows // 2
center_col = cols // 2

for i in range(rows):
    for j in range(cols):
        
        # Top or Bottom border
        if i == 0 or i == rows - 1:
            print("*", end="")
        
        # Left or Right border
        elif j == 0 or j == cols - 1:
            print("*", end="")
        
        # Center star
        elif i == center_row and j == center_col:
            print("*", end="")
        
        # Empty space
        else:
            print(" ", end="")
    
    print()