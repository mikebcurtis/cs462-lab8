ruleset Location {
  meta {
    name "Foursquare location"
    description <<
      Interacts with foursquare, displays last location. Lab 8.
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
  
  rule location_catch is active {
    select when location notification
    pre {
    	lat = event:attr("lat");
    	lng = event:attr("lng");
    }
    noop();
    fired {
    	set ent:lat lat;
    	set ent:lng lng;
    }
  }
  
  rule location_show is active {
    pre {
      my_html = <<
        <h5>Lat: #{ent:lat}</h5>
        <h5>Lng: #{ent:lng}</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("CS462 Lab 8: Dispatching Events Exercise", {}, my_html);
    }
  } 
}
