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



function buildConfFromArray(parsed) {
  var new_applet = ""
  parsed.sort((a, b) => ((a.config.length > 2 || a.config[1] > b.config[1]) ) ? a.config[1] - b.config[1]: -1)
  for (var pp = 0; pp < parsed.length; pp++) {
    if (parsed[pp] == null) continue;
    new_applet += buildConf(parsed[pp]);
  }
  return new_applet;
}

function scaleElements(applets, srcModel, dstModel) {

  const scale = (dstModel.width * 1.0) / (srcModel.width )
  console.log("scale um ", scale, srcModel, dstModel);
  var conf = applets.split(";")
  var newApplet = ""
  for (const ff of conf.slice(0, conf.length - 1)) {
    var appletConf = ff.split(":");

    newApplet += appletConf[0] + ":"
    var measures = appletConf[1].split(",")
    for (var i = 0; i < measures.length; i++) {
      newApplet +=  (Math.round(measures[i] * scale )) + ",";  
    }
    newApplet = newApplet.slice(0, -1) + ";"
  }
  return newApplet
}

function build_container(attributes, geo) {
  for (const tt in attributes) {
    if (attributes[tt][0].indexOf("ItemGeometries") == 0) continue;
    geo.push(attributes[tt]);
  }
  return geo
}
function moveWidgets(model, content, srcScreen, dstScreen) {
  var geo = [];
  const srcModel = model.find(x => x.id == srcScreen)
  const dstModel = model.find(x => x.id == dstScreen)
  content = content.split("\n\n");
  var marked = -1;
  var parsed = parseFile(content);
  for (var _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    if (parsed[_pj_c] == null) continue;
    if (parsed[_pj_c].config.length === 2 && parsed[_pj_c].config[0] === "Containments" && (parsed[_pj_c].config[1] == srcScreen + 1 || parsed[_pj_c].config[1] == dstScreen + 1  )) {
      var attributes = parsed[_pj_c].attributes
      if  (parsed[_pj_c].config[1] == srcScreen + 1)
        for (var _pj_f = 0; _pj_f < attributes.length; _pj_f += 1) {
          var att = attributes[_pj_f];
          if ((att[0].indexOf("ItemGeometries")) == 0) {
            var newGeo = parsed[_pj_c].attributes.splice(_pj_f, 1)[0]
            newGeo[1] = scaleElements(newGeo[1], srcModel, dstModel)
            console.log("inco", newGeo[1]);
            geo.push([newGeo[0], newGeo[1]])
            _pj_f--;
          } 
        }
      else if (srcScreen < dstScreen) {
        parsed[_pj_c].attributes = build_container(parsed[_pj_c].attributes, geo); 
      }
      else {
        marked = _pj_c;
      }
    }
    else if (parsed[_pj_c].config.length > 2 && parsed[_pj_c].config[0] === "Containments" && parsed[_pj_c].config[1] == srcScreen + 1 && parsed[_pj_c].config[2] === "Applets") {
      parsed[_pj_c].config[1] = dstScreen + 1;
      if (parsed[_pj_c].config.length > 3 && parsed[_pj_c].config[2] == "Applets" && parsed[_pj_c].config[4] == "Configuration" && 1) {
        for (var i = 0; i < parsed[_pj_c].attributes.length; i++) {
          if (["Weight", "Height", "Width"].some(sub => parsed[_pj_c].attributes[i][0].includes(sub))) {
            parsed[_pj_c].attributes[i][1] = Math.round(parsed[_pj_c].attributes[i][1] * ((srcModel.width * 1.0) / dstModel.width ))
            console.log("parsed[_pj_c].attributes", parsed[_pj_c].attributes[i][1])
          }
            
        }
      }
    }
    
  } 
  if (marked > -1) {
    parsed[marked].attributes = build_container(parsed[marked].attributes, geo);
  }
  return buildConfFromArray(parsed)
}


function CountApplets(parsed, screen=0) {
  var i = 0;
  for (var  _pj_c = 0; _pj_c < parsed.length; _pj_c += 1) {
    var par = parsed[_pj_c];
    if (par.config == null) continue;
    if (par.config.length > 2 && par.config[0] === "Containments" && par.config[1] == screen + 1 && par.type == 1) {
      i++;
    }
  }
  return i;
}

function ParseCountsApplets(content, screen=0) {
  var parsed = parseFile(content.split("\n\n"))
  return CountApplets(parsed, screen);
}

function mostApplets(content, screens_count) {
  var max = 0;
  var index = 0;
  var parsed = parseFile(content.split("\n\n"))
  for (var i = 0; i < screens_count; i++) {
    var tmp = CountApplets(parsed, i)
    if (tmp  > max) {
      max = tmp;
      index = i; 
    }
  }
  return index;
}