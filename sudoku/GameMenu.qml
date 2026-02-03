// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;
import controls.FocusablePanel;
import "DifficultyChooser.qml";
import "PlayerChooser.qml";

Item {
	id: mainMenu;
	focus: true;

	property alias keyboardVisible: keyboard.visible;

	signal newGameEvent(difficulty, player,diffInt);
	signal playEvent(difficulty,player);
	signal difficultySet(difficulty);
	signal helpEvent();
	signal enablePlayBtnEvent(player,diffInt);

	Image {
		 id: mainMenuTheme;
		 anchors.horizontalCenter: safeArea.horizontalCenter;
		 anchors.verticalCenter: safeArea.verticalCenter;
		 source: "apps/sudoku/img/ground_main.png";

	}

	BodyText {
		id: playerLabel;

		anchors.top: mainMenuTheme.top;
		anchors.topMargin: 253hph;
		anchors.left: mainMenuTheme.left;
		anchors.leftMargin: 440hpw;

		color: "#581B18";
		text: "PLAYER:";
	}

	PlayerChooser {
			id: playerChooser;

			width: 350hpw;

			anchors.left: mainMenuTheme.left;
			anchors.leftMargin: 518hpw;
			anchors.top: mainMenuTheme.top;
			anchors.topMargin: 246hph;

			onDownPressed: {
				difficultyChooser.setFocus();

			}

			onSelectPressed: { keyboard.visible = true; }

			onCurrentIndexChanged: {
				parent.enablePlayBtnEvent(playerChooser.listView.model.get(playerChooser.listView.currentIndex).player,
					difficultyChooser.listView.model.get(difficultyChooser.listView.currentIndex).factor);
			}
	}

	BodyText {
		id:levelLabel;

		anchors.horizontalCenter: playerLabel.horizontalCenter;
		anchors.top: playerLabel.bottom;
		anchors.topMargin: 42hph;

		color: "#581B18";
		text: "LEVEL:";
	}


	DifficultyChooser {
			id: difficultyChooser;

			width: 350hpw;

			anchors.left: mainMenuTheme.left;
			anchors.leftMargin: 518hpw;
			anchors.top: mainMenuTheme.top;
			anchors.topMargin: 315hph;

			onUpPressed: {
				playerChooser.setFocus();
			}

			onDownPressed: {
				newGameButton.setFocus();
			}

			onCurrentIndexChanged: {
				parent.difficultySet(this.listView.currentIndex+1);
				parent.enablePlayBtnEvent(playerChooser.listView.model.get(playerChooser.listView.currentIndex).player,
					difficultyChooser.listView.model.get(difficultyChooser.listView.currentIndex).factor);
			}
	}

	FocusablePanel {
		id: newGameButton;
		anchors.top: difficultyChooser.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.topMargin: 10hph;
//		anchors.bottomMargin: 10hph;
		width: 250hpw;
		height: 50hph;
		font: titleFont;

		radius: 0;

		Image {
			id:dcDelegateImgage;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
			source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
		}

		BodyText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: "#581B18";
			text:"New Game";
		}

		onUpPressed: {
			difficultyChooser.setFocus();
		}

		onDownPressed: {
			playButton.enabled?playButton.setFocus():helpButton.setFocus();
		}

		onSelectPressed: {
			console.log("newGameButton PRESSED!");
			parent.newGameEvent(mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).name,
				mainMenu.playerChooser.listView.model.get(playerChooser.currentIndex).player,
				mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).factor);
		}
	}

	FocusablePanel {
		id: playButton;
		anchors.top: newGameButton.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.topMargin: 5hph;

		width: 250hpw;
		height: 50hph;
		enabled: false;


		Image {
			id:dcDelegateImgage;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
			source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
		}

		BodyText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: "#581B18";
			text:"Play";
		}


		onUpPressed: {
			newGameButton.setFocus();
		}

		onDownPressed: {
			helpButton.setFocus();
		}

		onSelectPressed: {
			console.log("playButton PRESSED!");
			parent.playEvent(mainMenu.difficultyChooser.listView.model.get(difficultyChooser.currentIndex).text,
				mainMenu.playerChooser.listView.model.get(playerChooser.currentIndex).text);
		}
	}


	FocusablePanel {
		id: helpButton;
		anchors.top: playButton.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		width: 250hpw;
		height: 50hph;
		anchors.topMargin: 5hph;

		font: titleFont;
		text: "Help";
		color: "#00000000";


		Image {
			id:dcDelegateImgage;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
			source: "apps/sudoku/img/btn_main_"+(parent.enabled?(parent.activeFocus? "focus":"regular"):"disabled")+".png";
		}


		BodyText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: "#581B18";
			text:"Help";
		}

		onUpPressed: {
			playButton.enabled?playButton.setFocus():newGameButton.setFocus();
		}

		onDownPressed: {
		}

		onSelectPressed: {
			console.log("helpButton PRESSED!");
			parent.helpEvent();

		}
	}

	InputKeyboard {
		id: keyboard;

		defaultLangCode: "";

		savedWordsGroup: "GamesNickname";

		onAccepted: (text) {
			console.log("set player name" + text);
			mainMenu.playerChooser.listView.model.setProperty(mainMenu.playerChooser.currentIndex, 'player', text);
		}

		onVisibleChanged: {
			if (!visible)
				mainMenu.playerChooser.setFocus();
		}
	}

	function loadPlayers(data) {
		console.log("loading players..");

		if(!(this.players = load("sudokuPlayers")))
		{
			this.players = data ["players"];
		}

		for (var i = 0; i < this.players.length; ++i)
		{
			mainMenu.playerChooser.append(this.players[i]);
		}

		console.log("loading difficulty levels..");
		this.difflevels = data ["difflevels"];
		for (var  i= 0; i< this.difflevels.length; ++i )
		{
			mainMenu.difficultyChooser.append(this.difflevels[i]);
		}
	}

	function reFillPlayerChooser(data){
			 mainMenu.playerChooser.listView.model.reset();
			 for(var i =0; i<data.count; ++i){
					 mainMenu.playerChooser.append({player: data.get(i)['player']});
			 }
	}

	function savePlayers()
	{
		var players =[];
		for(var i =0 ;i<mainMenu.playerChooser.listView.model.count;++i){
			players.push(mainMenu.playerChooser.listView.model.get(i));
		}
		console.log("plaerys "+players);
		save("sudokuPlayers",players);
	}

	function reset() { keyboard.resetLanguage(); }
}

