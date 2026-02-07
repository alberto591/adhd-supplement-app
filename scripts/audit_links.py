import re
import sys

def audit_study_links(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        return

    # Split content into individual supplement blocks roughly
    # This regex looks for the start of a map with an 'id' field
    # It's a heuristic but should work for the structured data in seeding_service.dart
    
    # Strategy: iterating through the file line by line might be safer for nested structures
    # but regex on blocks is faster if the formatting is consistent.
    # The file seems to have "id": "..." as the start of a supplement item within the list.
    
    # Let's try to extract blocks based on "id": "..."
    # We will split by `    {` which usually starts a new item in the list
    
    # Actually, a better way is to find all `studyLinks` blocks and their context.
    # But context is hard with just regex.
    
    # detailed state machine parsing
    lines = content.split('\n')
    
    current_supplement_id = None
    main_study_keys = set()
    it_study_keys = set()
    es_study_keys = set()
    
    in_main_study_links = False
    in_it_study_links = False
    in_es_study_links = False
    
    # track where we are
    in_translations = False
    in_it = False
    in_es = False
    
    errors = []
    
    for i, line in enumerate(lines):
        line = line.strip()
        
        # Detect new supplement ID
        id_match = re.search(r'"id":\s*"([^"]+)"', line)
        if id_match:
            # If we were processing a supplement, verify it before ensuring clean state
            if current_supplement_id:
                check_alignment(current_supplement_id, main_study_keys, it_study_keys, es_study_keys, errors)
            
            # Reset for new supplement
            current_supplement_id = id_match.group(1)
            main_study_keys = set()
            it_study_keys = set()
            es_study_keys = set()
            in_main_study_links = False
            in_translations = False
            in_it = False
            in_es = False
            in_it_study_links = False
            in_es_study_links = False

        # Detect start of main studyLinks
        if '"studyLinks": {' in line:
            if in_it:
                in_it_study_links = True
            elif in_es:
                in_es_study_links = True
            else:
                in_main_study_links = True
            continue
            
        # Detect end of a map
        if line.startswith('}'):
            if in_it_study_links:
                in_it_study_links = False
            elif in_es_study_links:
                in_es_study_links = False
            elif in_main_study_links:
                in_main_study_links = False
            
            # Handle closing of translation blocks sections
            # This logic is a bit brittle, relies on indentation or structure
            # But simple check: if we see "}," or "}" and we were in a study link block, we just exited it.
            # We need to stay in "in_it" until we see the end of "it" block.
            # Let's rely on keys extraction mainly.
        
        # Detect translations block start
        if '"translations": {' in line:
            in_translations = True
            continue
            
        # Detect language blocks
        if '"it": {' in line:
            in_it = True
            in_es = False
            continue
        if '"es": {' in line:
            in_es = True
            in_it = False
            continue

        # Extract keys
        # Format: "Key Name":
        key_match = re.search(r'"([^"]+)":', line)
        if key_match:
            key = key_match.group(1)
            
            # Filter out keys that are not study link keys (like "name", "description" etc appearing in other maps)
            # We only care if we are INSIDE a studyLinks block
            if in_main_study_links:
                main_study_keys.add(key)
            elif in_it_study_links:
                it_study_keys.add(key)
            elif in_es_study_links:
                es_study_keys.add(key)

    # Check last one
    if current_supplement_id:
        check_alignment(current_supplement_id, main_study_keys, it_study_keys, es_study_keys, errors)
        
    if not errors:
        print("SUCCESS: All study links are perfectly aligned.")
    else:
        print(f"FOUND {len(errors)} ALIGNMENT ERRORS:")
        for err in errors:
            print(err)

def check_alignment(supp_id, main, it, es, errors):
    # Ignore supplements that might not have study links if main is empty
    if not main:
        return

    # Check It
    it_diff_missing = main - it
    it_diff_extra = it - main
    
    if it_diff_missing:
        errors.append(f"[{supp_id}] IT missing keys: {it_diff_missing}")
    if it_diff_extra:
        errors.append(f"[{supp_id}] IT extra/wrong keys: {it_diff_extra}")

    # Check Es
    es_diff_missing = main - es
    es_diff_extra = es - main
    
    if es_diff_missing:
        errors.append(f"[{supp_id}] ES missing keys: {es_diff_missing}")
    if es_diff_extra:
        errors.append(f"[{supp_id}] ES extra/wrong keys: {es_diff_extra}")

if __name__ == "__main__":
    audit_study_links("/Users/lycanbeats/Desktop/adhd_supplement_app/lib/infrastructure/services/seeding_service.dart")
