this.getPromoCatalog = function (url) {
    var request = new XMLHttpRequest();
    request.open("GET", "https://api.ivi.ru/mobileapi/videos/v5", false);
    request.send();
    
    if (request.readyState === XMLHttpRequest.DONE)
      if (request.status && request.status === 200)
        return JSON.parse(request.responseText);
      else {
        log("ivi::getPromoCatalog(): ", request.status, request.statusText);
        return;
      }
}
