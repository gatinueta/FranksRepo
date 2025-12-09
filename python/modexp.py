import sys

mod=int(sys.argv[1]) 
output_file = 'table.html'

print ( 'exp:', ''.join([ f'{n:>3}' for n in range(mod+1) ]), 'ord')
print()
ords = {}
exps = {}

for i in range(mod):
    b=[1]
    for exp in range(mod):
        n = (b[-1] * i) % mod
        b.append(n)

    if i>0: 
        try:
            ord = b.index(1, 1)
        except:
            ord=-1
        print (f'{i:>3}:', ''.join([ f'{n:>3}' for n in b ]), f'{ord:>3}')
        ords[i] = ord
        exps[i] = b

print(ords)
distinct_ords = set(ords.values())
sorted_ords = list(distinct_ords)
sorted_ords.sort()

incr = 200 // len(sorted_ords)
color_val = 0
color = {}
for ord in sorted_ords:
    color[ord] = color_val
    color_val += incr


html = [
    "<!DOCTYPE html>",
    "<html>",
    "<head>",
    "<meta charset='utf-8'>",
    "<style>",
    "table { border-collapse: collapse; }",
    "td { width: 40px; height: 40px; text-align: center; font-size: 18px; border: 1px solid #555; }",
    "</style>",
    "</head>",
    "<body>",
    "<table>"
]

for i in range( mod):
    html.append("<tr>")
    if i>0: 
        exps_row = exps[i]
        value_ord = ords[i]
        cell_value =  f'{i} ({value_ord})'
        cell_color_hint = 256-color[value_ord]
        cn = f"{cell_color_hint:02x}"
        cell_color = f"#{cn}ff{cn}"    
    else:
        cell_value = 'a (ord(a))'
        cell_color = '#00ff00'
    
    html.append(f"<td style='background-color:{cell_color}'>{cell_value}</td>")
    for exp in range(mod):
        if i==0:
            cell_value = f'a<sup>{exp}</sup>'
            cell_color = '#00ff00'
        else:
            cell_value = exps_row[exp]
            value_ord = ords[cell_value]
            cell_color_hint = 256-color[value_ord]
            cn = f"{cell_color_hint:02x}"
            cell_color = f"#{cn}{cn}{cn}"

        html.append(f"<td style='background-color:{cell_color}'>{cell_value}</td>")
    html.append("</tr>")    
html.extend(["</table>", "</body>", "</html>"])

with open(output_file, "w") as f:
    f.write("\n".join(html))
    f.write("\n")

print(f"Saved as {output_file}")


