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

const DST_FILE = "/.config/plasma-org.kde.plasma.desktop-appletsrc"

function parse_file(content) {
    elements = [];
  
    for (var conf, _pj_c = 0, _pj_a = content, _pj_b = _pj_a.length; _pj_c < _pj_b; _pj_c += 1) {
      conf = _pj_a[_pj_c];
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
  
    for (var conf, _pj_c = 0, _pj_a = content, _pj_b = _pj_a.length; _pj_c < _pj_b; _pj_c += 1) {
      conf = _pj_a[_pj_c];
  
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
  
    for (var pp, _pj_c = 0, _pj_a = par.attributes, _pj_b = _pj_a.length; _pj_c < _pj_b; _pj_c += 1) {
      pp = _pj_a[_pj_c];
      new_applet += pp[0] + "=" + pp[1] + "\n";
    }
  
    new_applet += "\n";
    return new_applet;
}

function move_to_display(content, src_screen, dst_screen) {
    var config, line, new_applet;
    new_applet = "";
  
    for (var conf, _pj_c = 0, _pj_a = content, _pj_b = _pj_a.length; _pj_c < _pj_b; _pj_c += 1) {
      conf = _pj_a[_pj_c];
  
      for (var line, _pj_f = 0, _pj_d = conf.split("\n"), _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
        line = _pj_d[_pj_f];
        console.log("line", line);
  
        if (line === "") {
          continue;
        }
  
        if (line[0] === "[") {
          config = line.slice(1, -1).split("][");
          console.log("Config", config);
  
          if (config.length > 2) {
            console.log("next", config.length > 2, config[1], config[2], "\n", config[1] === src_screen.toString(), config[2] === "Applets");
  
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
  