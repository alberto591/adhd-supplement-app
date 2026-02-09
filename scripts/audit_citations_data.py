#!/usr/bin/env python3
import re
import json
import os

def parse_seeding_service():
    file_path = 'lib/infrastructure/services/seeding_service.dart'
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return []

    with open(file_path, 'r') as f:
        content = f.read()

    # Extract the List<Map<String, dynamic>> defaultSupplements content
    # We use a regex to find the start and a brace counter for the end
    match = re.search(r'static const List<Map<String, dynamic>> defaultSupplements = \[', content)
    if not match:
        print("Could not find defaultSupplements list")
        return []

    start_index = match.end()
    brace_count = 1
    list_content = ""
    
    for i in range(start_index, len(content)):
        char = content[i]
        if char == '[':
            brace_count += 1
        elif char == ']':
            brace_count -= 1
        
        if brace_count == 0:
            list_content = content[start_index:i]
            break
        
    # Split list_content into individual supplement maps
    supp_blocks = []
    current_block = ""
    map_brace_count = 0
    in_string = False
    
    for char in list_content:
        if char == '"' and (not current_block or current_block[-1] != '\\'):
            in_string = not in_string
        
        if not in_string:
            if char == '{':
                map_brace_count += 1
            elif char == '}':
                map_brace_count -= 1
        
        current_block += char
        
        if map_brace_count == 0 and char == '}' and not in_string:
            supp_blocks.append(current_block.strip())
            current_block = ""
            
    # Parse each block to extract id, name, and studyLinks
    audit_results = []
    for block in supp_blocks:
        id_match = re.search(r'"id":\s*"([^"]+)"', block)
        name_match = re.search(r'"name":\s*"([^"]+)"', block)
        
        if id_match and name_match:
            supp_id = id_match.group(1)
            supp_name = name_match.group(1)
            
            # Extract main studyLinks
            links = {}
            # Simplified studyLinks extractor - look for keys between "studyLinks": { and }
            links_match = re.search(r'"studyLinks":\s*{(.*?)}', block, re.DOTALL)
            if links_match:
                links_text = links_match.group(1)
                for entry in re.findall(r'"([^"]+)":\s*"([^"]+)"', links_text):
                    links[entry[0]] = entry[1]
            
            # Extract translations studyLinks
            translations = {}
            trans_match = re.search(r'"translations":\s*{(.*?)\s*}\s*\n\s*}', block, re.DOTALL)
            if trans_match:
                trans_text = trans_match.group(1)
                # Find "it": { ... } and "es": { ... }
                for locale in ['it', 'es']:
                    locale_match = re.search(fr'"{locale}":\s*{{(.*?)\s*}}', trans_text, re.DOTALL)
                    if locale_match:
                        locale_content = locale_match.group(1)
                        locale_links = {}
                        loc_links_match = re.search(r'"studyLinks":\s*{(.*?)}', locale_content, re.DOTALL)
                        if loc_links_match:
                            loc_links_text = loc_links_match.group(1)
                            for entry in re.findall(r'"([^"]+)":\s*"([^"]+)"', loc_links_text):
                                locale_links[entry[0]] = entry[1]
                        translations[locale] = locale_links
            
            audit_results.append({
                'id': supp_id,
                'name': supp_name,
                'links': links,
                'translations': translations
            })
            
    return audit_results

def main():
    results = parse_seeding_service()
    
    print(f"Auditing {len(results)} supplements...")
    print("-" * 50)
    
    for item in results:
        print(f"Supplement: {item['name']} ({item['id']})")
        
        if not item['links']:
            print("  ⚠️ NO MAIN LINKS FOUND")
        else:
            for title, url in item['links'].items():
                print(f"  [EN] {title}: {url}")
                
        for locale, trans_links in item['translations'].items():
            if not trans_links:
                print(f"  ⚠️ NO {locale.upper()} LINKS FOUND")
            else:
                for title, url in trans_links.items():
                    print(f"  [{locale.upper()}] {title}: {url}")
        print("-" * 50)

if __name__ == "__main__":
    main()
