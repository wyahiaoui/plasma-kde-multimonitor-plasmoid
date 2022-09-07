class AppletDesktopContainments {
    constructor() {
      this.index = null;
      this.type = null;
      this.config = null;
      this.attributes = [];
    }
  
    printApplet() {
      console.log("config", "[" + this.config.join("][") + "]");
      console.log("attributes", this.attributes);
    }
  
}


function parseFile(content) {
  var elements = [];

  for (var _pj_c = 0; _pj_c < content.length; _pj_c += 1) {
    var conf = content[_pj_c].split("\n");

    var element = new AppletDesktopContainments();

    for (var _pj_f = 0; _pj_f < conf.length; _pj_f += 1) {
      var line = conf[_pj_f];
      // console.log("LIENNEEE", line)
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
        var splitted = line.split("=");
        element.attributes += [[splitted[0], splitted.length > 1 ? splitted[1] : ""]];
      }
    }

    
    // element.printApplet()
    if (typeof(element) != "object")
      console.log("elem", typeof(element), element.config)
    elements.push(element);
  }
  
  return elements;
}
  

function removeApplets(content) {
    var config, newApplet, skip;
    skip = false;
    newApplet = "";
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
            newApplet += line + "\n";
          }
        } else {
          newApplet += line + "\n";
        }
      }
  
      if (!skip) {
        newApplet += "\n";
      }
  
      skip = false;
    }
  
    return newApplet;
}
  
function buildConf(par) {
    var newApplet;
    newApplet = "[" + par.config.join("][") + "]\n";
  
    for (var pp, _pj_c = 0, content = par.attributes, _pj_b = content.length; _pj_c < _pj_b; _pj_c += 1) {
      pp = content[_pj_c];
      newApplet += pp[0] + "=" + pp[1] + "\n";
    }
  
    newApplet += "\n";
    return newApplet;
}

function moveToDisplay(content, srcScreen, dstScreen) {
  var config, line, newApplet;
  newApplet = "";
  content = content.split("\n\n")
  srcScreen += 1;
  dstScreen += 1;
  for (var  _pj_c = 0; _pj_c < content.length; _pj_c += 1) {
    var conf = content[_pj_c];

    for (var _pj_f = 0, _pj_d = conf.split("\n"); _pj_f < _pj_d.length; _pj_f += 1) {
      var line = _pj_d[_pj_f];

      if (line === "") {
        continue;
      }

      if (line[0] === "[") {
        config = line.slice(1, -1).split("][");

        if (config.length > 2) {

          if (config[1] === srcScreen.toString() && config[2] === "Applets") {
            config[1] = dstScreen.toString();
            line = "[" + config.join("][") + "]";
          }
        }

        newApplet += line + "\n";
      } else {
        newApplet += line + "\n";
      }
    }

    newApplet += "\n";
  }

  return newApplet;
}

function mostApplet() {

}

function moveWidgets(content, srcScreen, dstScreen) {
  var forwarded, geo, holden, newApplet, parsed, stop;
  newApplet = "";
  forwarded = "";
  content = content.split("\n\n");
  parsed = parseFile(content);
  holden = "";
  geo = "";
  stop = false;
  srcScreen += 1;
  dstScreen += 1;
  for (var  _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    var par = parsed[_pj_c];

    if (par.config.length === 2 && par.config[0] === "Containments" && (par.config[1] === dstScreen || par.config[1] === srcScreen)) {
      if (par.config[1] === srcScreen) {
        newApplet += "[" + "][".join(par.config) + "]\n";

        for (var _pj_f = 0, _pj_d = par.attributes; _pj_f < _pj_d.length; _pj_f += 1) {
          var att = _pj_d[_pj_f];

          if (!att[0].startswith("ItemGeometries")) {
            newApplet += att[0] + "=" + att[1] + "\n";
          } else {
            geo += att[0] + "=" + att[1] + "\n";
          }
        }

        newApplet += "\n";

        if (Number.parseInt(srcScreen) > Number.parseInt(dstScreen)) {
          stop = true;
        }
      } else {
        if (par.config[1] === dstScreen) {
          newApplet += "[" + "][".join(par.config) + "]\n";
          newApplet += geo;

          for (var pp, _pj_f = 0, _pj_d = par.attributes, _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
            pp = _pj_d[_pj_f];

            if (!pp[0].startswith("ItemGeometries")) {
              newApplet += pp[0] + "=" + pp[1] + "\n";
            }
          }

          newApplet += holden + "\n";
          // console.log("comp", Number.parseInt(srcScreen), Number.parseInt(dstScreen), Number.parseInt(srcScreen) > Number.parseInt(dstScreen));
        }
      }

      newApplet += "\n";
    } else {
      if (par.config.length > 2 && par.config[0] === "Containments" && par.config[1] === srcScreen && par.config[2] === "Applets") {
        par.config[1] = dstScreen;

        if (Number.parseInt(srcScreen) > Number.parseInt(dstScreen)) {
          newApplet += buildConf(par);
        } else {
          holden += buildConf(par);
        }
      } else {
        newApplet += buildConf(par);

        if (stop && par.config.length > 1 && par.config[1] !== dstScreen) {
          forwarded += newApplet;
          stop = true;
          newApplet = "";
        }
      }
    }
  }
}


function countsApplets(content, screen=0) {
  var parsed = parseFile(content.split("\n\n"))
  var i = 0;
  for (var  _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    var par = parsed[_pj_c];
    if (par.config == null) continue;
    if (par.config.length > 2 && par.config[0] === "Containments" && par.config[1] == screen + 1 && par.type == 1) {
      // console.log("Screen", par.config[1])
      i++;
    }
  }
  return i;
}