{
    if (NR == 1) {
        print > "data/dev.csv";
        print > "data/train.csv";
    }
    else if (NR % 20 == 2) {
        print > "data/dev.csv";
    }
    else {
        print > "data/train.csv";
    }
}
