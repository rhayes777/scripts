file="conf"
while read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    echo $line
done < "$file"