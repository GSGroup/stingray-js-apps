import "ReversiCell.qml";

Grid {
	id: boardItem;

	columns: 8;
	rows: 8;
	width: childrenWidth;
	height: childrenHeight;
	focus: true;

	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}
	ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {} ReversiCell {}

	property int cursorX: 3;
	property int cursorY: 3;
	property bool playerWhite: true;
	property int difficultyLevel: 0;

	Rectangle {
		id: cursor;
		color: "#0000";
		borderWidth: 6;
		borderColor: boardItem.playerWhite? "#fff": "#000";
		radius: 5;

		width: 65;
		height: 65;
		x: boardItem.cursorX * 65;
		y: boardItem.cursorY * 65;

		Behavior on x { animation: Animation { duration: 200; } }
		Behavior on y { animation: Animation { duration: 200; } }
	}

	onUpPressed: {
		if (cursorY > 0) --cursorY;
	}

	onDownPressed: {
		if (cursorY < 7) ++cursorY;
	}

	onLeftPressed: {
		if (cursorX > 0) --cursorX;
	}

	onRightPressed: {
		if (cursorX < 7) ++cursorX;
	}

	native {
		ReversiCell *Get(int y, int x) const { int idx = y * 8 + x; return argile_cast<ReversiCell *>(children.at(idx)); }
		int MakeMove(int y, int x, bool white, bool simulate) const;
		int GetPositionalBonus(int y, int x, bool white);

		struct State {
			int state[8][8];
		};

		void Save(State &state);
		void Restore(State &state);

		void Reset() {
			for(int i = 0; i < 8; ++i) for(int j = 0; j < 8; ++j) {
				ReversiCell *cell = Get(i, j);
				if ((i == 3 && j == 3) || (i == 4 && j == 4))
					cell->disc = ReversiCell::Disc::White;
				else if ((i == 3 && j == 4) || (i == 4 && j == 3))
					cell->disc = ReversiCell::Disc::Black;
				else
					cell->disc = ReversiCell::Disc::Empty;
			}
			cursorX = 3;
			cursorY = 3;
		}

		bool NextMove(bool white, bool simulate);

	}
}

