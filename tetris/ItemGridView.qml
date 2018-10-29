import "ItemDelegate.qml";
import "tetrisConsts.js" as gameConsts;

GridView {
	orientation: Vertical;
	cellWidth: gameConsts.getBlockSize();
	cellHeight: gameConsts.getBlockSize();

	model: ListModel {
		property int value;
		property int colorIndex;
	}
	delegate: ItemDelegate { }
}
