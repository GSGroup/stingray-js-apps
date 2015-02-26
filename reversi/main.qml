import Game

Application {
	id: reversiItem;
	name: "reversi2";
	displayName: "myreversi";
	focus: true;

	Game {
		id: game;
	}
}

/*
	ContextMenu {
		id: contextMenu;
		anchors.fill: parent;
		onItemChoosed: {
			switch (index) {
			case ContextMenu::RedButton:
				if (aiMoveTimer.running) //ai is "thinking"
					return;
				board.NextMove(board.playerWhite, false);
				reversiItem.UpdateStats();
				aiMoveTimer.Start();
				break;
			case ContextMenu::GreenButton:
				board.playerWhite = true;
				reversiItem.Reset();
				reversiItem.UpdateStats();
				break;
			case ContextMenu::YellowButton:
				board.playerWhite = false;
				reversiItem.Reset();
				reversiItem.UpdateStats();
				break;
			case ContextMenu::BlueButton:
				int d = board.difficultyLevel + 1;
				if (d > 1) //0..1 for now
					d = 0;
				log("changing difficulty to " + d);
//??????? ZapperSettings
				ZapperSettings::Get()->Write("reversiDifficultyLevel", d);

				board.difficultyLevel = d;
				reversiItem.updateDifficultyLevel();
				break;
			}
		}
	}
//?????setMenuItemText
	updateDifficultyLevel: {
		switch(board.difficultyLevel) {
		case 0: contextMenu.setMenuItemText(3, tr("Easy")); break;
		case 1: contextMenu.setMenuItemText(3, tr("Hard")); break;
		}
	}

//??????ContextMenu
	onVisibleChanged: {
		ContextMenu::ContextMenuItemVector items;
		items.reserve(4);
		items.push_back(self->tr("Help"));
		items.push_back(self->tr("Start with white"));
		items.push_back(self->tr("Start with black"));
		items.push_back(std::string());
		contextMenu->setItems(items);
		self->updateDifficultyLevel();
	}

	onCompleted: {
		board.Reset();
		//????
		board.difficultyLevel = ZapperSettings::Get()->Read<int>("reversiDifficultyLevel");
	}
*/
