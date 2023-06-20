use Lingy::Test;

tests <<'...';
- [ '5 (+ 3 3) 7', "5\n6\n7", "Multiple expressions on one line works" ]

- [ '(+)', 0 ]
- [ '(+ 2)', 2 ]
- [ '(+ 2 3)', 5 ]
- [ '(+ 2 3 4)', 9 ]
- [ '(+ 2 3 4 5)', 14 ]
- [ '(+ 2 3 4 5 6)', 20 ]

- [ '(-)', "Wrong number of args (0) passed to function" ]
- [ '(- 2)', -2 ]
- [ '(- 2 3)', -1 ]
- [ '(- 2 3 4)', -5 ]
- [ '(- 2 3 4 5)', -10 ]

- [ '(*)', 1 ]
- [ '(* 2)', 2 ]
- [ '(* 2 3)', 6 ]
- [ '(* 2 3 4)', 24 ]
- [ '(* 2 3 4 5)', 120 ]

- [ '(/)', "Wrong number of args (0) passed to function" ]
- [ '(/ 2)', 0.5 ]
- [ '(/ 360 2)', 180 ]
- [ '(/ 360 2 3)', 60 ]
- [ '(/ 360 2 3 4)', 15 ]
- [ '(/ 360 2 3 4 5)', 3 ]
...
