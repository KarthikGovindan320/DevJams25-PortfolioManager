import pandas as pd

def extract_columns_from_csv(input_file, output_file):
    columns_to_extract = ['Date', 'Stock', 'Author', 'Target', 'LTP', 'Upside(%)']
    
    try:
        print(f"Reading CSV file: {input_file}")
        df = pd.read_csv(input_file)
        
        print(f"Original file shape: {df.shape}")
        print(f"Original columns: {list(df.columns)}")
        
        missing_columns = [col for col in columns_to_extract if col not in df.columns]
        if missing_columns:
            print(f"Warning: The following columns are missing: {missing_columns}")
            available_columns = [col for col in columns_to_extract if col in df.columns]
            columns_to_extract = available_columns
            print(f"Extracting available columns: {columns_to_extract}")
        
        extracted_df = df[columns_to_extract].copy()
        
        print(f"Extracted data shape: {extracted_df.shape}")
        print(f"Extracted columns: {list(extracted_df.columns)}")
        
        extracted_df.to_csv(output_file, index=False)
        print(f"Successfully saved extracted data to: {output_file}")
        
        print("\nFirst 5 rows of extracted data:")
        print(extracted_df.head())
        
        return extracted_df
        
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
        return None
    except Exception as e:
        print(f"Error processing file: {str(e)}")
        return None

if __name__ == "__main__":
    input_filename = "tabletoChange.csv"
    output_filename = "extracted_data.csv" 
    
    result = extract_columns_from_csv(input_filename, output_filename)
    
    if result is not None:
        print(f"\nExtraction completed successfully!")
        print(f"Input file: {input_filename}")
        print(f"Output file: {output_filename}")
    else:
        print("Extraction failed. Please check the file path and try again.")
