{
    split($1, array1, "/");
    split(array1[4], array2, ".");
    split(array2[1], words, "-")
    printf("[")
    for (i = 1; i <= length(words); i++) {
        printf("%s%s ", toupper(substr(words[i],1,1)), substr(words[i],2) );
    }
    printf("](%s)\n", $1)
    printf("\n");
}