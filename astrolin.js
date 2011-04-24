(function() {
  var app, express, jade, path, port, util, _;
  util = require('util');
  path = require('path');
  jade = require('jade');
  _ = require('massagist')._;
  express = require('express');
  app = express.createServer();
  app.helpers({
    keys: function(a) {
      return _.keys(a);
    },
    projects: {
      lin: {
        tracker: "265847"
      },
      sin: {
        tracker: "203533",
        package: "gravity"
      },
      eden: {
        tracker: "203533"
      }
    },
    linkage: function(project, details) {
      var defaults, github, key, links, _i, _len, _ref;
      if (details === void 0) {
        return {
          "project's unknown": "/"
        };
      }
      github = "https://github.com/astrolet/";
      defaults = {
        package: project,
        source: project,
        issues: "" + project + "/issues"
      };
      details = _.defaults(details, defaults);
      links = {};
      _ref = ["source", "tracker", "package"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        if (details[key] !== false) {
          if (details[key].match(/^http/)) {
            links[key] = details[key];
          } else {
            switch (key) {
              case "package":
                links[key] = "http://search.npmjs.org/#/" + details[key];
                break;
              case "tracker":
                links[key] = "https://www.pivotaltracker.com/projects/" + details[key];
                break;
              case "source":
              case "issues":
                links[key] = "" + github + details[key];
            }
          }
        }
      }
      return links;
    }
  });
  app.configure(function() {
    var node_server;
    node_server = path.normalize(__dirname);
    app.set('root', node_server);
    app.use(express.logger());
    app.use(app.router);
    app.use(express.static(node_server + '/public'));
    app.set('views', node_server + '/views');
    app.register('.html', jade);
    app.set('view engine', 'html');
    app.set('view options', {
      layout: true
    });
    return app.enable('show exceptions');
  });
  app.get("/", function(req, res, next) {
    return res.render("index", {
      title: "Welcome"
    });
  });
  app.get("/to/:project?", function(req, res, next) {
    if (req.params.project == null) {
      req.params.project = "lin";
    }
    return res.render("project", {
      title: req.params.project,
      headest: "",
      project: req.params.project,
      forehead: "<br/>" + req.params.project.toUpperCase()
    });
  });
  process.addListener('uncaughtException', function(err) {
    return util.puts("Uncaught Exception: " + (err.toString()));
  });
  port = parseInt(process.env.C9_PORT || process.env.PORT || 8001);
  app.listen(port, null);
  console.log("Express been started on :%s", port);
}).call(this);
