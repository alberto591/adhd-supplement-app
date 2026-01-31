import re
import json

def find_supplements(content):
    # This is a very rough parser for the dart list structure
    # It looks for the supplement maps inside the list
    supplements = []
    
    # Simple regex to split by id: "id"
    parts = re.split(r'\{\s+"id":\s+"', content)
    for part in parts[1:]:
        # Re-add the start of the object
        obj_str = '{"id": "' + part
        
        # We need to find the end of this supplement object.
        # This is tricky without a real parser, but since they are well formatted...
        # We'll look for the next ID or the end of the list.
        # Searching for the end is safer: "      }," at the end of a translations block? 
        # No, let's just use the start of the next one as a boundary.
        # For the last one, it's just the end of the file/list.
    return parts[1:]

def check_translations(content):
    # Use a more robust regex that handles nested translations better
    supp_blocks = re.findall(r'\{\s+"id":\s+"([^"]+)"(.*?)\"translations\":\s+\{(.*?)\n\s+        \},', content, re.DOTALL)
    
    required_fields = [
        'name', 'description', 'mechanismOfAction', 'detailedBenefits', 
        'timingRationale', 'dosageFrequency', 'dosageWarnings', 'tldr', 'sideEffects'
    ]
    
    results = []
    for supp_id, main_body, trans_body in supp_blocks:
        missing = {"it": [], "es": []}
        
        # Check which fields are in the main body (English)
        present_in_en = []
        for field in required_fields:
            if f'"{field}":' in main_body:
                present_in_en.append(field)
        
        # Check IT translations
        it_match = re.search(r'"it":\s+\{(.*?)\},', trans_body, re.DOTALL)
        if it_match:
            it_content = it_match.group(1)
            for field in present_in_en:
                if f'"{field}":' not in it_content:
                    missing["it"].append(field)
        else:
            missing["it"] = present_in_en

        # Check ES translations
        es_match = re.search(r'"es":\s+\{(.*?)\}', trans_body, re.DOTALL) # Might not have trailing comma
        if es_match:
            es_content = es_match.group(1)
            for field in present_in_en:
                if f'"{field}":' not in es_content:
                    missing["es"].append(field)
        else:
            missing["es"] = present_in_en
            
        if missing["it"] or missing["es"]:
            results.append({"id": supp_id, "missing": missing})
            
    return results

if __name__ == "__main__":
    with open("lib/infrastructure/services/seeding_service.dart", "r") as f:
        content = f.read()
    
    results = check_translations(content)
    print(json.dumps(results, indent=2))
