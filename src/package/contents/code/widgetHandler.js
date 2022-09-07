class AppletDesktopContainments {
    constructor() {
      this.index = null;
      this.type = null;
      this.config = null;
      this.attributes = [];
    }
  
    print_applet() {
      console.log("config", "[" + "][".join(this.config) + "]");
      console.log("attributes", this.attributes);
    }
  
}


function parse_file(content) {
  content = content.split("\n\n")
  elements = [];

  for (var _pj_c = 0; _pj_c < content.length; _pj_c += 1) {
    var conf = content[_pj_c];
    element = new AppletDesktopContainments();

    for (var line, _pj_f = 0, _pj_d = conf.split("\n"), _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
      line = _pj_d[_pj_f];

      if (line === "") {
        continue;
      }

      if (line[0] === "[") {
        element.config = line.slice(1, -1).split("][");

        if (element.config.length === 2 && element.config[0] === "Containments") {
          element.index = element.config[1];
          element.type = 0;
        } else {
          if (element.config.length > 2 && element.config[2] === "Applets") {
            element.index = element.config[1];
            element.type = 1;
          }
        }
      } else {
        attribute = {};
        splitted = line.split("=");
        element.attributes += [[splitted[0], splitted.length > 1 ? splitted[1] : ""]];
      }
    }

    elements += [element];
  }

  return elements;
}
  

function remove_applets(content) {
    var config, new_applet, skip;
    skip = false;
    new_applet = "";
    content = content.split("\n\n")
    for (var _pj_c = 0; _pj_c < content.length; _pj_c += 1) {
      var conf = content[_pj_c];
  
      for (var line, _pj_f = 0, _pj_d = conf.split("\n"), _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
        line = _pj_d[_pj_f];
  
        if (line === "") {
          skip = false;
          continue;
        }
  
        if (skip) {
          continue;
        }
  
        if (line[0] === "[") {
          config = line.slice(1, -1).split("][");
  
          if (config.length > 2 && config[2] === "Applets") {
            skip = true;
          }

          if (skip) {
            continue;
          } else {
            new_applet += line + "\n";
          }
        } else {
          new_applet += line + "\n";
        }
      }
  
      if (!skip) {
        new_applet += "\n";
      }
  
      skip = false;
    }
  
    return new_applet;
}
  
function build_conf(par) {
    var new_applet;
    new_applet = "[" + "][".join(par.config) + "]\n";
  
    for (var pp, _pj_c = 0, content = par.attributes, _pj_b = content.length; _pj_c < _pj_b; _pj_c += 1) {
      pp = content[_pj_c];
      new_applet += pp[0] + "=" + pp[1] + "\n";
    }
  
    new_applet += "\n";
    return new_applet;
}

function move_to_display(content, src_screen, dst_screen) {
  var config, line, new_applet;
  new_applet = "";
  content = content.split("\n\n")
  for (var conf, _pj_c = 0, content = content, _pj_b = content.length; _pj_c < _pj_b; _pj_c += 1) {
    conf = content[_pj_c];

    for (var line, _pj_f = 0, _pj_d = conf.split("\n"), _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
      line = _pj_d[_pj_f];

      if (line === "") {
        continue;
      }

      if (line[0] === "[") {
        config = line.slice(1, -1).split("][");

        if (config.length > 2) {

          if (config[1] === src_screen.toString() && config[2] === "Applets") {
            config[1] = dst_screen.toString();
            line = "[" + "][".join(config) + "]";
          }
        }

        new_applet += line + "\n";
      } else {
        new_applet += line + "\n";
      }
    }

    new_applet += "\n";
  }

  return new_applet;
}
  
function move_widgets(content, src_screen, dst_screen) {
  var forwarded, geo, holden, new_applet, parsed, stop;
  new_applet = "";
  forwarded = "";
  content = content.split("\n\n");
  parsed = parse_file(content);
  holden = "";
  geo = "";
  stop = false;

  for (var  _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    var par = parsed[_pj_c];

    if (par.config.length === 2 && par.config[0] === "Containments" && (par.config[1] === dst_screen || par.config[1] === src_screen)) {
      if (par.config[1] === src_screen) {
        new_applet += "[" + "][".join(par.config) + "]\n";

        for (var _pj_f = 0, _pj_d = par.attributes; _pj_f < _pj_d.length; _pj_f += 1) {
          var att = _pj_d[_pj_f];

          if (!att[0].startswith("ItemGeometries")) {
            new_applet += att[0] + "=" + att[1] + "\n";
          } else {
            geo += att[0] + "=" + att[1] + "\n";
          }
        }

        new_applet += "\n";

        if (Number.parseInt(src_screen) > Number.parseInt(dst_screen)) {
          stop = true;
        }
      } else {
        if (par.config[1] === dst_screen) {
          new_applet += "[" + "][".join(par.config) + "]\n";
          new_applet += geo;

          for (var pp, _pj_f = 0, _pj_d = par.attributes, _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
            pp = _pj_d[_pj_f];

            if (!pp[0].startswith("ItemGeometries")) {
              new_applet += pp[0] + "=" + pp[1] + "\n";
            }
          }

          new_applet += holden + "\n";
          console.log("comp", Number.parseInt(src_screen), Number.parseInt(dst_screen), Number.parseInt(src_screen) > Number.parseInt(dst_screen));
        }
      }

      new_applet += "\n";
    } else {
      if (par.config.length > 2 && par.config[0] === "Containments" && par.config[1] === src_screen && par.config[2] === "Applets") {
        par.config[1] = dst_screen;

        if (Number.parseInt(src_screen) > Number.parseInt(dst_screen)) {
          new_applet += build_conf(par);
        } else {
          holden += build_conf(par);
        }
      } else {
        new_applet += build_conf(par);

        if (stop && par.config.length > 1 && par.config[1] !== dst_screen) {
          forwarded += new_applet;
          stop = true;
          new_applet = "";
        }
      }
    }
  }
}
