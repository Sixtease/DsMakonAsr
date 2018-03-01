{
    if (NR == 1) {
        print > "data/wide-dev.csv";
        print > "data/wide-train.csv";
    }
    else if (NR % 20 == 2) {
        print > "data/wide-dev.csv";
    }
    else {
        print > "data/wide-train.csv";
    }
}
