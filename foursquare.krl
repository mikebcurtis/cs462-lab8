ruleset Foursquare {
  meta {
    name "Foursquare"
    description <<
      Interacts with foursquare.
    >>
    author "Mike Curtis"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  
  rule process_fs_checkin is active {
    select when foursquare checkin
    pre {
      checkin = event:attr("checkin").decode();
      venue = checkin.pick("$..venue.name");
      city = checkin.pick("$..city");
      shout = checkin.pick("$..shout");
      createdAt = checkin.pick("$..createdAt");
	  lat = checkin.pick("$..lat");
	  lng = checkin.pick("$..lng");
    }
    {
      send_directive(venue) with checkin = venue;
    }
    fired {
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
	  set ent:lat lat;
	  set ent:lng lng;
      raise pds event new_location_data with key = "fs_checkin" and value = {"venue":venue,"city":city,"shout":shout,"createdAt":createdAt,"lat":lat,"lng":lng};
    }
  }
  
  rule display_checkin is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Venue: #{ent:venue.as("str")}</h5>
        <h5>City: #{ent:city.as("str")}</h5>
        <h5>Shout: #{ent:shout.as("str")}</h5>
        <h5>CreatedAt: #{ent:createdAt.as("str")}</h5>
        <h5>Lat: #{ent:lat}</h5>
        <h5>Lng: #{ent:lng}</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("CS462 Lab 5: Foursquare Checkins", {}, my_html);
    }
  }
}
