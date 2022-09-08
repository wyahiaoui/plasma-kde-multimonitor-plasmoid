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
      if (line === null || line == "") {
        continue;
      }

      if (line[0] === "[") {
        element.config = line.slice(1, -1).split("][");
        element.index = element.config[1];
        if (element.config.length === 2 && element.config[0] === "Containments") {
          element.type = 0;
        } else if (element.config.length > 2 && element.config[2] === "Applets") {
           
          element.type = 1;
        }
        else {
          element.type = 2;
        }
      } else {
        var splitted = line.split("=");
        element.attributes.push([splitted[0], splitted.length > 1 ? splitted[1] : ""]);
      }
    }
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
    
    for (var _pj_c = 0; _pj_c < par.attributes.length; _pj_c += 1) {
      var pp = par.attributes[_pj_c];
      
      newApplet += pp[0] + "=" + pp[1] + "\n";
    }
  
    newApplet += "\n";
    return newApplet;
}



function _moveToDisplay(content, srcScreen, dstScreen) {
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
  console.log("neew", newApplet)
  return newApplet;
}

function buildConfFromArray(parsed) {

}

function moveWidgets(content, srcScreen, dstScreen) {
  var geo = [];
  content = content.split("\n\n");
  var parsed = parseFile(content);
  for (var _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    if (parsed[_pj_c] == null) continue;
    if (parsed[_pj_c].config.length === 2 && parsed[_pj_c].config[0] === "Containments" && (parsed[_pj_c].config[1] == srcScreen + 1 || parsed[_pj_c].config[1] == dstScreen + 1  )) {
      // console.log("adljd", parsed[_pj_c].attributes.length)
      var attributes = parsed[_pj_c].attributes
      if  (parsed[_pj_c].config[1] == srcScreen + 1)
        for (var _pj_f = 0; _pj_f < attributes.length; _pj_f += 1) {
          var att = attributes[_pj_f];
          console.log("aartlrj", att);
            if ((att[0].indexOf("ItemGeometries")) == 0) {
              geo.push(parsed[_pj_c].attributes.splice(_pj_f, 1))
              _pj_f--;
            } 
        }
      else {
        for (const tt in parsed[_pj_c].attributes) {
          if (parsed[_pj_c].attributes[tt][0].indexOf("ItemGeometries") == 0) continue;
          geo.push(parsed[_pj_c].attributes[tt]);
        }
        parsed[_pj_c].attributes = geo; 
      }
    }
    else if (parsed[_pj_c].config.length > 2 && parsed[_pj_c].config[0] === "Containments" && parsed[_pj_c].config[1] == srcScreen + 1 && parsed[_pj_c].config[2] === "Applets") {
      parsed[_pj_c].config[1] = dstScreen + 1;
    }
  }
  parsed.sort((a, b) => (a.config.length > 2 || a.config[1] > b.config[1]) ? a.config[1] - b.config[1]: -1)
  var new_applet = ""
  for (var pp = 0; pp < parsed.length; pp++) {
    // console.log("papapapaap", parsed[pp])
    if (parsed[pp] == null) continue;
    // console.log("parsed", buildConf(parsed[pp]))
    new_applet += buildConf(parsed[pp]);
    // if (pp == 4)
    //   break;
  }
  return new_applet
}

function _moveWidgets(content, srcScreen, dstScreen) {
  var forwarded, geo, holden, newApplet, parsed, stop;
  newApplet = "";
  forwarded = "";
  content = content.split("\n\n");
  parsed = parseFile(content);

  holden = "";
  geo = "";
  stop = false;
  for (var  _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    var par = parsed[_pj_c];
    
    if (par.config == null) continue;
    if (par.config.length === 2 && par.config[0] === "Containments" && (par.config[1] == dstScreen + 1 || par.config[1] == srcScreen + 1)) {
      if (par.config[1] == srcScreen + 1) {
        newApplet += "[" + par.config.join("][") + "]\n";
        for (var _pj_f = 0; _pj_f < par.attributes.length; _pj_f += 1) {
          var att = par.attributes[_pj_f];
          if ((att[0].indexOf("ItemGeometries")) != 0) {
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
        if (par.config[1] == dstScreen + 1) {
          newApplet += "[" + par.config.join("][") + "]\n";
          newApplet += geo;
          for (var pp, _pj_f = 0, _pj_d = par.attributes, _pj_e = _pj_d.length; _pj_f < _pj_e; _pj_f += 1) {
            pp = _pj_d[_pj_f];
            if (pp[0].indexOf("ItemGeometries") != 0) {
              newApplet += pp[0] + "=" + pp[1] + "\n";
            }
          }

          newApplet += holden + "\n";
          // console.log("neeew", newApplet)
          // console.log("comp", Number.parseInt(srcScreen), Number.parseInt(dstScreen), Number.parseInt(srcScreen) > Number.parseInt(dstScreen));
        }
      }

      newApplet += "\n";
    } else {
      if (par.config.length > 2 && par.config[0] === "Containments" && par.config[1] == srcScreen + 1 && par.config[2] === "Applets") {
        par.config[1] = dstScreen + 1;

        if (Number.parseInt(srcScreen) < Number.parseInt(dstScreen)) {
          newApplet += buildConf(par);
        } else {
          holden += buildConf(par);
          console.log("hold", holden)
        }
      } else {
        newApplet += buildConf(par);

        if (stop && par.config.length > 1 && par.config[1] != dstScreen + 1) {
          forwarded += newApplet + holden;
          stop = true;
          newApplet = "";
        }
      }
    }
  }
  return forwarded + newApplet
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