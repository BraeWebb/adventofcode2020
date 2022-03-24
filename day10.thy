chapter "Day 10"
theory day10
imports Main day1
begin

type_synonym model = "char list list"

definition OOB :: char where "OOB = hd ''%''"
definition OCCUPIED :: char where "OCCUPIED = hd ''#''"
definition EMPTY :: char where "EMPTY = CHR ''L''"
definition FLOOR :: char where "FLOOR = hd ''L''"


definition input1 :: model where
  "input1 = [
''L.LL.LL.LL'',
''LLLLLLL.LL'',
''L.L.L..L..'',
''LLLL.LL.LL'',
''L.LL.LL.LL'',
''L.LLLLL.LL'',
''..L.L.....'',
''LLLLLLLLLL'',
''L.LLLLLL.L'',
''L.LLLLL.LL''
  ]"

fun adjacent_positions :: "model \<Rightarrow> (int \<times> int) \<Rightarrow> (int \<times> int) list" where
  "adjacent_positions m (x, y) = [
    (x - 1, y - 1),
    (x, y - 1),
    (x + 1, y - 1),

    (x - 1, y),
    (x + 1, y),

    (x - 1, y + 1),
    (x, y + 1),
    (x + 1, y + 1)
  ]"

fun index_or_oob :: "'a \<Rightarrow> 'a list \<Rightarrow> int \<Rightarrow> 'a" where
  "index_or_oob d l i = (if i < 0 \<or> i \<ge> int (length l) then d else l!(nat i))"

fun lookup :: "model \<Rightarrow> (int \<times> int) \<Rightarrow> char" where
  "lookup m (x, y) = index_or_oob OOB (index_or_oob [] m y) x"

fun adjacent_cells :: "model \<Rightarrow> (int \<times> int) \<Rightarrow> char list" where
  "adjacent_cells m (x, y) = map (lookup m) (adjacent_positions m (x, y))"

value "adjacent_cells input1 (9, 9)"
value "adjacent_positions input1 (0, 0)"

value "lookup input1 (0, -1)"

fun count :: "'a \<Rightarrow> 'a list \<Rightarrow> int" where
  "count s [] = 0" |
  "count s (x # xs) = (if x = s then 1 else 0) + count s xs"

fun adjacent :: "model \<Rightarrow> (int \<times> int) \<Rightarrow> int" where
  "adjacent m (x, y) = count OCCUPIED (adjacent_cells m (x, y))"


fun convert :: "model \<Rightarrow> (int \<times> int) \<Rightarrow> char" where
  "convert m pos = (case (lookup m pos) of
    CHR ''L'' \<Rightarrow> (if (adjacent m pos) = 0 then OCCUPIED else EMPTY) |
    CHR ''#'' \<Rightarrow> (if (adjacent m pos) \<ge> 4 then EMPTY else OCCUPIED) |
    _ \<Rightarrow> (lookup m pos))"


fun positions :: "int \<Rightarrow> int \<Rightarrow> (int \<times> int) list" where
  "positions w i = map (\<lambda>x. (x mod w, x div w)) [0..i-1]"

fun slice :: "(nat \<times> nat) \<Rightarrow> 'a list \<Rightarrow> 'a list" where
  "slice (start, end) s = take (end - start + 1) (drop start s)"


fun div_col :: "nat \<Rightarrow> char list \<Rightarrow> char list list" where
  "div_col 0 x = []" |
  "div_col c [] = []" |
  "div_col c m = (slice (0, c - 1) m) # div_col c (slice (c, length m) m)"


fun iterate_model :: "model \<Rightarrow> model" where
  "iterate_model m = (let col = (length (m!0)) in
    div_col col (map (convert m) (positions (int col) (int (col * length m))))
  )"

fun sum :: "int list \<Rightarrow> int" where
  "sum [] = 0" |
  "sum (x#xs) = x + sum xs"
fun occupied :: "model \<Rightarrow> int" where
  "occupied m = sum (map (count OCCUPIED) m)"

value "iterate_model input1"
value "iterate_model (iterate_model input1)"

value "positions 10 100"
value "div_col 10 (map (lookup input1) (positions 10 100))"

value "div_col 10 (map (convert input1) (positions 10 100))"

inductive iterate_star :: "model \<Rightarrow> model \<Rightarrow> bool" where
  "\<lbrakk>n = iterate_model m;
    occupied n = occupied m\<rbrakk>
    \<Longrightarrow> iterate_star m n" |

  "\<lbrakk>n = iterate_model m;
    occupied n \<noteq> occupied m;
    iterate_star n n'\<rbrakk>
    \<Longrightarrow> iterate_star m n'"

code_pred [show_modes] iterate_star .

values "{occupied n | n . iterate_star input1 n}"

definition input2 :: model where
  "input2 = [
''LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLL.LLLL.LLLL.LLLLLLLLLL.LLLLLL.LLLLL'',
''LLLLL.LLLL.LLLLL.LLLLL.L.LLLLLL.LLLL.LLLLLL.LL....LLLLLLLL.LLLLLLLLL.LLLL.LLLLLLLLLL.LLLLLLL'',
''LLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLL.LLLLL.LLLLL.LL.LLLLLL.L.'',
''LLLLLLLLLL.LLL...LLLLL.LLLLLLLL.L.LLLLLLLLLLLLL.LLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLL..LLLL.LLLL.LL...LLLLLLLLLL.LLLLLL.LLLLL'',
''LL.LLLLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLL.L.LLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL'',
''LLLLLLLLLL.L.LLLL.LLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''.L...L...LLLL..LLL......L.LLL.L.L.....L...L..L.L................L...L...L.LLLL.......LLL....'',
''L..LLLLLLL.LLLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL..LLLLL.LLLL.LLLLLL.LLL.L'',
''LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLL.LLLLLL.LLL.L'',
''LLL.LLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLLL.LLL.LLLLLLL.LLLLLL.LLLLLLLLLLLLL.LLLLLL....LL'',
''LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLL.LLLLLLL.LL.LLLL.L.L.LLL'',
''LLLLLL.LLL.L.LL.LL.LLL.LLLLLLLL.LLLL.LLLLL.LLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLLLLL.LL.LL.LLLLL.LLLL.LLLLLLLLLLLLLLL..LLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLL'',
''.LL.....LLLL.L..L..L..L...L.L..L..L.L....LL..L...LLL...LL.....L..LL....L...LLL..L...LLL..LLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLL.L.LLLL.LLLLLLLL..LLLLL.LLLLL.L.LLLL.LLLLLLL.LLLLLLLLLLLL.LLLLL'',
''LLLLLLLLLLLL.LLL.LLL.LL.LLLLLLL.LLLL.LLLLLLLLL..LLLL.LLLLLLLLLLLL.LL.LLLLLLLL.LLLLLLLLLLLLLL'',
''LLLLLLLLLLLLLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLL..LLLLLLLLLLLLLLL.LLLLL.LLLL.LLLLL.LLL.LL.LLLLL'',
''LLLLLL.L..LLLLLL.LLLLLLLL.LLLLLLLLLLLLL.LLLLLL.LLLLL.LLLLLLLLL.LLLLL.LLLLLLLLLL.LLLL.LLLLLLL'',
''LLLLLLLLLL.LLLLLLLLLLL..LLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLL..LLLLLLLL..LLLL.LLLLL.LLLLLLLLLLLL'',
''LLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLL.LLLLLLLLLLLLLLL.L..LL.LL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLLLLLLLLL.LLL.LLL.LLLLLLLLLLLLLL.LLLLL.LLLLL.LLLLLLLLL.L.LL.LLLLLLLLLLLLLLLLLL'',
''L.LLLLLLLL.LLL.LL.LL.LLLLLLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLLL.LLLLL.LLLLL'',
''L..LL...L.L..L..L.L..L.L.L..L.LL.L....LL....LL.L...L..LL..LLL....L...LL...L..L.L....L....LLL'',
''LLLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLL.LLLLLLLLL..LLL.L.LLLLLLLLLL.LLLLL'',
''LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLLLLLLLL.LLLLLLLL.LLLLL.LLLL.LLLLL.L'',
''LLLLLLLLLL.LLLLLL.LLLLLLLLLLLL.LLLLLLLLLLLLL.L.LLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLLLLLLLLL.LLLLL'',
''LLLLLLLLLLLLLLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLL.L.LLLLL.LLLLL.L.LLLL.LLLLLL.LLLLLLLLLLLLLLLLLLL'',
''.LL......LLL....LL.L....LLL.L.L....L.LLL....L....L..L...L.......LL.....L...L.L..L.LLLL......'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.L.LL.LLLLLLLLLLLLLLL.LLLLLLL.LL.LLLLLLL.L.LL.LL.LLL.LLLLLLLL'',
''LLLLLLLLLL.LLLLL.L.LLL.LLLLLL.L.LLLL.LLLLLLLLLLLLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLLLLL.L..LLLLLLLLLLLLLLL..LLL.LL.LLLLLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLL..LLL.LLLLLLLLL.LLLLL.LLLLLLLLLL.LLLL.LLLL.LLLLL.LLL.LL.L.LLL'',
''LLLLLLLLLL.LLLLLLLLLL.LLLLLL.LL.LLLL.LLLLLL.LL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLL'',
''LLLLLLL.LL.LLLLL.LLLLL.L.LLLL.L.LLLL.LLLLLLLLL.LLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLL.LLLL.LLLL.LLLLL.LLLLL.LLLLLLLLL.LLL..LLLLL.LLLLLLLLLLLL'',
''LLLLLLLL.LLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLL.L.LLLLL.L.LLLL.LLLLL'',
''L...L.L...L...L.LL.........LL..........LLL.....LLL.....L...L.L..LL......L.L..LL.LL...L.L....'',
''.LLLLLLLLL.LLL.L.LLLL..L.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LL..LLLL.LL.L.LLLLLL.LLLL.LLLLLLLLLLLLLLL.LLLLL.LLLLLLLLL.LLL..LLLLLLLLLLLL.LLLLL'',
''LLLLLLL.LLLLLLLL.LLLLL.LLL.LLLL.LLLL.L.LLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLL.LL..LLLL'',
''LLLLLLLLLLLLLLLL.LL.LLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''LLL.LLL.LL.LLLLLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLL..LLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLLL'',
''.L.LLLLLLL.LL.LL.LLL.L.LLLLLLLL..LLL..LL.LLLLLLLLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''.LLLLLLLLL..LLLLL.LLL..LLLLLLLL.LLL..LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL..LLLL.LLLLLLLLLLLL..LLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLL..LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''L...L..L.....LL.L...........L...........LL.....L.L.L..L.........LLLLL...L.L..LL..L..L......L'',
''LLLLLLLLLLLLLLLL.LL.LL.LLLLLLLL.LLLL.LLLLL..LLLLLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL..LLLL.LL.LL.L.LLLLLLLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLL.LL.LLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLL.LLL.L'',
''LLLLLLLLLL.L.LL.LLLLLLLLLLLLLLL.LLLL..LLLLLLLL.LLLLL.LLLLL.LLLLLLLLL..LLL.LLLLLLLLLLLL.LLL.L'',
''L.LLLLLLLL.LLL.L.LLLLLLLLLLL.LL.LLLLLLLLLLLLLL.LLL.L.LLLLL.L.LLLLLLL.LLLLLLLLLL.LLLLLL.LLLLL'',
''LLLLLLLL.L.LLLLL.LLLLL...LL.LLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLL.LLLLLLLLLL.LLLLLLL.LLLL'',
''LLLLL.LL..LLLLLLLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLL.L.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLLL.LLL.LLLLL.L.LLL.LLLLLLLLL.LLLL.LLLLL..L.LLL.LLLLL'',
''LL...L.L..L.L....LL...LLLL..L...............L...........L.L.LL..L..L.LLL...LL......LLL..L..L'',
''LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL..LLLLL.LLLLL'',
''.LL.LLLLLLLLLLLLLLLLL.L.LLLLLLL.LLL.LLLLLLLLLL.LLLLL.LLLLLLLLLLLLLLL.LLL...LLLL.LLLLLLLLLLLL'',
''.LLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLLL.LLLLLL.LLLL.LLL.LLLLLLLLLLLLL.LLLLLLLLLL.LLLLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLLLL.LLL..LLLL.LL.L.LLLLLLLLLLLLLLL.LLLLLLLLL.LL'',
''LLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLL.L.LL.LL.LLLLLLLLL.LLLLLLLLLLLLLLL.LLLL.LLLLLLLLLL.LLLLLLL'',
''LLLLLLLLLL.LLLLL.LLLLLLLLLLL.LL.LLLLLLLLLLL.LL.LL.LLLLLLLL..LLLLLLLL.LLLL.LLLLL.LLLLLLLL.LLL'',
''LL.LLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLL.LLL.LLLLLLLLLL.L.LLLLL'',
''...L.L.....L.L..LL.LL..L.L...LLLL.......L.LLL...LL..L.L.L..L...L..L......LLL...L.L...L...L..'',
''LL.LLLLLL..LLLLL.LLL.LLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLL.LLLLLLLLLLLLLL..LLLLLLLLLLL.LLLLL'',
''LLLLLLLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLLLLL.LLLLLLLLLLL.LLLLL..LLLLLLLL.LL.L.LLLLLLLLLLLLLLLLLL'',
''LLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LL..LLLLLLLLLLLLLLLL.LLLLL.LL.LLLLLL.LLLL.LLL.L.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLL..LLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.L.LLLLLLLLLL'',
''L.LLLLLLLLLLLLLL.LLLLLLLLLLLLLL.L..L.LLLLLLLLL.LL.LL.LLLLLLLLL.LLLLLLLLLL.LLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLL.LL.LL.LLLLLLL..LL.L.LLLLLL.LL.LLLLLLLLLLL..LLLLLLLL.LLLLLLLLLL.LLLLL..LLLLL'',
''LLLLLLLLLLLLLLLL.LLLLL.LLLLLLL..LLLL.LLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLLLL.LLLLLLL'',
''LLLL.LLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LL.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLL.L..LLL.LLLLL'',
''L.LL.....LLLL.LL.LLL..L....LLL.L..LLL.....L.L.L...L.L.L..L.L......L.....LL..LL..L..LL.....L.'',
''LLLLLLLLLL.LLLL.LLLLLL.LLLLLLLL.LLLL.LLLL.LLLLLLLLLL.LLLLL.LLLLL.L.L.LLLLLLLLLLLLLLLLL.LLLLL'',
''LLLLL.LL...LLLLLLLLLLL.LL.LLLLL.L.LLLLLLLLLLLL.LLLLLLLLLL..LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLLL.LLLL.LLLLLLLL.LLLL.LLLLLLLLLLLLLL..LLLLLLLLLL.LLLL.LLL.L.LLLL.LLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLLL'',
''LLL.LLLLLL.LLLLLLLLLLLLL.LLLLLL.LLL..LL.LLLLLLLLLL.L.LLLLL.LLLLLL.L...LLL.LLLLLLLLLLLLLLLLLL'',
''LLLLLLLLLLL.LLLLLLLLLL.LLLLLLL.L.LLL.LLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLL'',
''LLLLLLLLLLLLLL...LLLLLL.LLLLLLLLLLLL.LLLLLLLLLL.LLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLLL'',
''L.......LL.L...LL...L......LL.L.....LL..L...L..L.LL........L.L..L.L.LL...L..L...LL..L.LLLL..'',
''LLLLLLLLLL.LLLLL.L.LLLLLLLLLLLL..LLL.LLLLLLLLL.LLLLL.LLLLL.LLLLL.LLL.LLLL.LLLLL.LLLLLLLL.LLL'',
''LLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLL.LLLLLLL.LLLLLLLL.LL.L.LLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLLL'',
''LLLL.LLLL.LLLLLL.LLL.L.LLLLLLL..LLLL.LLLLLLLLLLLLLLL.LLLLL.L.LLLLLLL.LLLLLLLLLL.LLLLLLLLLLLL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLL.LL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.L'',
''LLLLLL.LLL.LLLLL.L.LLL.LLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLL.L.LLL'',
''LLLLLLLLLL.LLLL.LLLLLLLLLLL.LLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLL.LLLLLL.LLLLL'',
''LL.LLLLLLL.LLLLL..LLLL..LLLLLLL.LLLL.LLLLLLLLLLLLL.L.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLLLLLLLL'',
''.L.L.L.LL..L.L.......L.....LLLL.L.....L.L.L...L.L..L.L..L..L.....LL.LL.L.......LL.L.L.....LL'',
''LLLLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLLLLLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLLLL'',
''LLLLLLLLLL.LL.LL.LLLLL.LLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLL..LLLLLLLLLLLLLLL.LLLLL'',
''LLLLLLLLLLLL.LLLLLLLLLLLLLLLL.L.LLLL.LL.LLLLLLLLLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLLLLL.LLLLLLLLL'',
''LLLLLLLLLLLL.LLL.LLLLL.LLLL.LLL.LLLL.LLLL.LLLL.LLLLL..L.LLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLLL'',
''L.LLLLLLLL.LLLLL.LLLLL.LLLLLLLL.LLLL..LLLLLLLL.LLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL..LLLLL.LLLLL'',
''LLLLLLLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLL..LLL.L.LLLLL'',
''LLLLLLLLLL.LLLLL.LLLLLLL.LLLLLL.LL.LLLLLLLLLLL.LLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLL.LLL.LLLLLLLL''
  ]"

value "iterate_model input2"

(*values "{occupied n | n . iterate_star input2 n}"*)

end