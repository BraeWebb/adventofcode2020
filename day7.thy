chapter "Day 7"
theory day7
imports Main
begin

type_synonym rules = "(string \<times> (nat \<times> string) list) list"

definition input1 :: rules where
  "input1 = [
(''light red'', [(1, ''bright white''), (2, ''muted yellow'')]),
(''dark orange'', [(3, ''bright white''), (4, ''muted yellow'')]),
(''bright white'', [(1, ''shiny gold'')]),
(''muted yellow'', [(2, ''shiny gold''), (9, ''faded blue'')]),
(''shiny gold'', [(1, ''dark olive''), (2, ''vibrant plum'')]),
(''dark olive'', [(3, ''faded blue''), (4, ''dotted black'')]),
(''vibrant plum'', [(5, ''faded blue''), (6, ''dotted black'')]),
(''faded blue'', []),
(''dotted black'', [])
  ]"

fun matching_rules :: "rules \<Rightarrow> string \<Rightarrow> rules" where
  "matching_rules r s = filter (\<lambda>(k, xs). s \<in> (set (map snd xs))) r"

fun maps_to :: "rules \<Rightarrow> string \<Rightarrow> string set" where
  "maps_to r s = set (map fst (matching_rules r s))"

value "maps_to input1 ''shiny gold''"

fun lookup :: "rules \<Rightarrow> string \<Rightarrow> (nat \<times> string) list" where
  "lookup r s = (map snd (filter (\<lambda>(k,v). k = s) r))!0"

fun lookup_strings :: "rules \<Rightarrow> string \<Rightarrow> string list" where
  "lookup_strings r s = (map snd (lookup r s))"

(*
fun reachable :: "rules \<Rightarrow> string \<Rightarrow> string set" where
  "reachable r s = (set (lookup_strings r s)) \<union> (fold (map (reachable r) (lookup_strings r s)))"

value "reachable input1 ''muted yellow''"
*)

end