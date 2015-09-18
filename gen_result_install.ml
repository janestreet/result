let is_prefix s ~prefix =
  let len = String.length prefix in
  String.length s >= len && String.sub s 0 len = prefix
;;

let () =
  let install_it = function
    | "META" -> true
    | "result.install" -> false
    | s -> is_prefix s ~prefix:"result."
  in
  let to_install =
    let ( |> ) x f = f x in
    Sys.readdir "."
    |> Array.to_list
    |> List.filter install_it
    |> List.sort String.compare
    |> List.map (Printf.sprintf "%S")
  in
  let oc = open_out "result.install" in
  Printf.fprintf oc "lib: [ %s ]\n"
    (String.concat " " to_install)
;;
