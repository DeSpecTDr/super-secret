open Lwt
open LTerm_geom
open LTerm_text
open LTerm_key

let rec loop ui =
  LTerm_ui.wait ui >>= function
    | LTerm_event.Key{ code = Escape; _ } ->
        return ()
    | _ ->
        loop ui

let draw ui matrix coord =
  let size = LTerm_ui.size ui in
  let ctx = LTerm_draw.context matrix size in
  LTerm_draw.clear ctx;
  LTerm_draw.draw_frame_labelled ctx { row1 = 0; col1 = 0; row2 = size.rows; col2 = size.cols } ~alignment:H_align_center (Zed_string.of_utf8 "") LTerm_draw.Light;
  if size.rows > 2 && size.cols > 2 then begin
    let color1 = B_fg (LTerm_style.rgb 255 69 0) in
    let whit = B_fg LTerm_style.white in
    let strin = " " in                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             let strin = strin ^ (* super omega secret (dont decode plz (its just a string)))*) (Base64.decode_exn "0JzQmNCo0JAg0KEg0JTQoCEhISEhISEhISEhISEhISEhISEhIQ==") in
    let pos = {row = int_of_float ((float_of_int coord.row) *. float_of_int size.rows /. 3000.) + size.rows / 2; col = int_of_float((float_of_int coord.col) *. float_of_int size.cols /. 3000.) + size.cols / 2;} in
    LTerm_draw.draw_styled ctx (pos.row - 3) pos.col (eval [color1; S "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"; E_fg]);
    LTerm_draw.draw_styled ctx (pos.row - 2) pos.col (eval [color1; S "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"; E_fg]);
    LTerm_draw.draw_styled ctx (pos.row - 1) pos.col (eval [color1; S "▄"; E_fg; whit; S "▄▄"; E_fg; color1; S "▄"; E_fg; whit; S "▄▄"; E_fg; color1; S "▄▄▄"; E_fg; whit; S "▄▄▄"; E_fg; color1; S "▄▄▄"; E_fg;]);
    LTerm_draw.draw_styled ctx (pos.row - 0) pos.col (eval [whit; S "▄▄▄▄▄▄▄"; E_fg; color1; S "▄"; E_fg; whit; S "▄▄"; E_fg; color1; S "▄▄▄▄▄"; E_fg;]);
    LTerm_draw.draw_styled ctx (pos.row + 1) pos.col (eval [whit; S "▄▄▄▄▄▄▄▄▄"; E_fg; color1; S "▄▄▄▄▄▄"; E_fg;]);
    LTerm_draw.draw_styled ctx (pos.row + 2) pos.col (eval [color1; S "▄▄▄▄"; E_fg; whit; S "▄"; E_fg; color1; S "▄"; E_fg; whit; S "▄"; E_fg; color1; S "▄▄▄▄▄▄▄▄"; E_fg;]);
    LTerm_draw.draw_styled ctx (pos.row + 3) pos.col (eval [color1; S "▄▄▄"; E_fg; whit; S "▄"; E_fg; color1; S "▄▄▄"; E_fg; whit; S "▄"; E_fg; color1; S "▄▄▄▄▄▄▄"; E_fg;]);
    LTerm_draw.draw_styled ctx (size.rows / 2) (size.cols / 2) (eval [B_bg LTerm_style.white; B_fg LTerm_style.red; S strin; E_bg; E_fg]);
  end

let main () =
  let coord = ref { row = 0; col = 0 } in

  
  Lazy.force LTerm.stdout
  >>= fun term ->
  LTerm_ui.create term (fun matrix size -> draw matrix size !coord)
  >>= fun ui ->
  Lwt.finalize (fun () ->
    ignore (Lwt_engine.on_timer 0.2 true (fun _ ->
      let t = Unix.time () /. 2. in
      coord := { row = int_of_float(1000. *. (sin t)); col = int_of_float(1000. *. (cos t)) };
      LTerm_ui.draw ui;)
    );
    loop ui) (fun () -> LTerm_ui.quit ui)

let () = Lwt_main.run (main ())