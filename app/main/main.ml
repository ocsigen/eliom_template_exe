(** This is the main file if you are using static linking without config file.
*)

let logdir = "local/var/log/project_name"
let dbfile = "local/var/data/project_name/ocsidb"
let rundir = "local/var/run"
let staticdir = "local/var/www/project_name"

(* The absolute links take the host name of the request. In production, behind a
   reverse proxy or when the application sends links by email, add
   [~usedefaulthostname:true] and give the public host name, port and protocol
   to [Ocsigen.Server.host] ([~default_hostname], [~default_httpport],
   [~default_protocol_is_https]): the links then use them, rather than the Host
   header of the request, which a client can forge. *)
let () =
  Ocsipersist_settings.set_db_file dbfile;
  Ocsigen.Server.start
    ~ports:[`All, 8080]
    ~veryverbose:() ~debugmode:true ~logdir ~uploaddir:(Some "/tmp")
    ~command_pipe:(Filename.concat rundir "project_name-cmd")
    ~default_charset:(Some "utf-8")
    [Ocsigen.Server.host [Staticmod.run ~dir:staticdir (); Eliom.App.run ()]]
