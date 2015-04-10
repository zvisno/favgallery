$(function(){

  var view = {

    init: function(){
      view.showBio();
      view.showWork();
      view.showEducation();
      $("#mapDiv").append(googleMap);
      initializeMap()
    },

    showBio: function(){
      var name, role, welcomeMsg, biopic, skills, contacts, mySkills;
      var mybio = controller.getBio();

      for (var property in mybio) {
        if (mybio.hasOwnProperty(property)) {
          if (property === "name") {
            name = controller.replaceValue(HTMLheaderName, mybio[property]);
          }

          if (property === "welcomeMessage") {
            welcomeMsg = controller.replaceValue(HTMLwelcomeMsg, mybio[property]);
          }

          if (property === "skills") {
            mySkills = mybio[property];
          }

          if (property === "contacts") {
            contacts = mybio[property];
          }
        }
      }

      $("#header").prepend(role);
      $("#header").prepend(name);
      $("#header").append(HTMLskillsStart);

      mySkills.forEach(function (item) {
        $("#skills").append(controller.replaceValue(HTMLskills, item));
      });

      $.each(contacts, function (key, value) {
        if (key !== "location") {
          var contactItem = HTMLcontactGeneric.replace("%data%", value).replace("%contact%", key);
          $("#footerContacts").append(contactItem)
        } else {
          $("#topContacts").append(controller.replaceValue(HTMLlocation, value));
        }
      });
    },

    showWork: function(){
      var mywork = controller.getWork();

      var myjobs;

      for (var property in mywork) {
        if (mywork.hasOwnProperty(property)) {
          if (property === "jobs"){
            myjobs = mywork[property];
          }
        }
      }

      for (var i = 0; i < myjobs.length; i++) {
        $("#workExperience").append(HTMLworkStart);
        for (var prop in myjobs[i]){
          if (prop === "dates"){
            $(".work-entry:last").append(controller.replaceValue(HTMLworkDates, myjobs[i][prop]));
          }
          if (prop === "description"){
            $(".work-entry:last").append(controller.replaceValue(HTMLworkDescription, myjobs[i][prop]));
          }
          if (prop === "location"){
            $(".work-entry:last").append(controller.replaceValue(HTMLworkLocation, myjobs[i][prop]));
          }
          if (prop === "title"){
            $(".work-entry:last").append(controller.replaceValue(HTMLworkTitle, myjobs[i][prop]));
          }

          if (prop === "employer"){
            $(".work-entry:last").append(controller.replaceValue(HTMLworkEmployer, myjobs[i][prop]));
          }

        }
      }

    },

    showEducation: function(){

      var education = controller.getEducation();

      var mySchools;

      for (var property in education) {
        if (education.hasOwnProperty(property)) {
          if (property === "schools"){
            mySchools = education[property];
          }
        }
      }

      for (var i = 0; i < mySchools.length; i++) {
        $("#education").append(HTMLschoolStart);
        for (var prop in mySchools[i]){
          if (prop === "dates"){
            $(".education-entry:last").append(controller.replaceValue(HTMLschoolDates, mySchools[i][prop]));
          }
          if (prop === "name"){
            $(".education-entry:last").append(controller.replaceValue(HTMLschoolName, mySchools[i][prop]));
          }
          if (prop === "location"){
            $(".education-entry:last").append(controller.replaceValue(HTMLschoolLocation, mySchools[i][prop]));
          }
          if (prop === "degree"){
            $(".education-entry:last").append(controller.replaceValue(HTMLschoolDegree, mySchools[i][prop]));
          }

          if (prop === "majors"){
            $(".education-entry:last").append(controller.replaceValue(HTMLschoolMajor, mySchools[i][prop]));
          }
        }
      }


    }
  };

  var controller = {
    init: function(){
      view.init()
    },

    replaceValue: function(element, value){
      return element.replace("%data%", value)
    },

    getEducation: function(){
      return model.education()
    },

    getBio: function(){
      return model.bio()
    },

    getWork: function(){
      return model.work()
    }
  };

  var model = {

    work: function(){
      var work = {
        "jobs": [
          {
            "employer": "AS Ideas Engineering",
            "title": "Software Test Engineer",
            "location": "Germany, Berlin",
            "dates": "April 2014 - Present",
            "description": "Test automation strategy for web and mobile applications, implementation of automated tests"
          },
          {
            "employer": "Fyber (former SponsorPay)",
            "title": "Software Quality Assurance Engineer",
            "location": "Germany, Berlin",
            "dates": "Sept 2012 - March 2014",
            "description": "Test strategy for web and mobile applications, implementation of automated tests"
          },

          {
            "employer": "Ciklum",
            "title": "Software Quality Assurance Engineer",
            "location": "Ukraine, Kyiv",
            "dates": "Sep 2011 - Aug 2012",
            "description": "Managed software development and quality processes in a team. Analysed the system, created and managed requirements. Wrote specification of the system and documentation of features."
          }
        ],
        "display": ""
      };

      return work
    },

    education: function(){
      var education = {
        "schools": [
          {
            "name": "University of Tartu",
            "location": "Estonia, Tartu",
            "dates": 2011,
            "degree": "Master in Software Engineering",
            "majors": []

          },
          {
            "name": "Vinnytsia National Technical University (VNTU)",
            "location": "Ukraine, Vinnytsia",
            "dates": 2007,
            "degree": "Bachelor in Software Security",
            "majors": []
          }
        ],
        "display": ""
        };

      return education
    },

    bio: function(){
      var bio = {
        "name": "Yuliya Brynzak",
        "role": "Software Developer",
        "contacts": {
          "twitter": "twitter.com/zvisno",
          "instagram": "instagram.com/protuberanci",
          "github": "github.com/zvisno",
          "location": "Berlin"
      },
        "welcomeMessage": "Make technologies to serve you, not serve to technologies",
        "skills": [
        "Software Test Automation",
        "Requirements Engineering",
        "Agile methodologies",
        "Software Engineering"
      ],
        "display": ""
      };


      return bio
    }

  };


controller.init()
});
