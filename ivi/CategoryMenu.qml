import controls.Button;


ListView {
    id: categoryMenu;

    spacing: 20;

    positionMode: Center;

    focus: true;

    model: ListModel {
        ListElement { title: "Промо-видео"; url: "https://api.ivi.ru/mobileapi/videos/v5"; }
        ListElement { title: "Советский кинематограф"; url: "https://api.ivi.ru/mobileapi/compilations/v5/"; }
    }

    delegate: Button {
        text: model.title;
    }
}
