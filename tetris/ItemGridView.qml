import "ItemDelegate.qml";
import "tetrisConsts.js" as gameConsts;

GridView {
	id:grid;

	property int animationTime: 0;

	orientation: Vertical;
	cellWidth: gameConsts.getBlockSize();
	cellHeight: gameConsts.getBlockSize();

	focus: false;
	handleNavigationKeys: false;

	model: ListModel {
		property int value;
		property int colorIndex;
		property int sizeW;
	}
	delegate: ItemDelegate { animationInterval: grid.animationTime; }
}
