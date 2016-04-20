import "ivi.js" as ivi;

ListModel {
    id: videoModel;

    getPromoVideos: {
        var self = this;
        var videos = ivi.getPromoVideos();
        videos["result"].forEach(function (video) {
            self.append( { title: video["title"], poster: video["thumbnails"][0]["path"] } );
        });
    }
}
