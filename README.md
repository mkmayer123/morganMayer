# battleShip
%Begin by working on placeShips and chooseShipLocation,
%then playTurn
function [] = battleShip()
    computerBoard = placeShips(); %placeShips creates a game board with ships placed on it
    playerBoard = char(zeros(8,8)); %Create an empby board to hold player knowledge
    while isGameWon(computerBoard) == false
        hitMiss = false;
        [playerBoard,computerBoard,hitMiss] = playTurn(playerBoard,computerBoard);
        if strcmp(hitMiss,'Hit') == true
           fprintf('Hit!\n');
        elseif strcmp(hitMiss,'Miss') == true
           fprintf('Miss!\n');
        elseif strcmp(hitMiss,'Error')
            clc;
            fprintf('Invalid selection, please try again.\n');
        elseif strcmp(hitMiss,'Duplicate')
            clc;
            fprintf('You have already fired on that location, please try again.\n');
        end
    end
end

function [playerBoard,computerBoard,hitMiss] = playTurn(playerBoard,computerBoard)
    displayBoard(playerBoard);
    
    %Get input from the player in the form of Letter,Number
    inputString = input('Enter grid coordinates (ex. A,1): ','s');
    disp(inputString);
    %If the length of the string is not 3, or the letter is not between A
    %and H, or the number is not between 1 and 8
    
	% TODO: 1) Write a conditional to validate the user input.
    % If the input is invalid, store an appropriate message in hitMiss,
    % then return
	% Hint: Messages can be seen in the battleShip() function
    % --Your code goes here--
      if length(inputString) ~= 3 || inputString(1)<65 || inputString(1)>72 || str2num(inputString(3))<1 || str2num(inputString(3))>8
        hitMiss='Error';
        return
      end
    
    %If the input is corrrect, then these lines will execute after the if
    i = inputString(1) - 64; %Converting from a letter, like 'A', to an integer, like 1
    j = str2double(inputString(3));
    
	% TODO: 2) Check to see if the player has missed. If so,
    % store an appropriate message in hitMiss and return.
	% Hint: If you don't know what value to look for to indicate a miss,
	% look through the code for the line where the board is made.
    if playerBoard(i,j)==char(0)
        hitMiss='Miss';
        playerBoard(i,j)='X';
        return
    end
    
    %If computerBoard(i,j) contains a ship, change the computerBoard and
    %playerBoard to reflect a hit with !, or an X for a miss on the
    %playerBoard only
	
	% TODO: 3) write an if block to check if the player has hit a ship,
    % or if the player has guessed a cell that they already checked.
	% Update the corresponding board(s),
    % and store an appropriate message in hitMiss in both cases.
   if computerBoard(i,j)=='S'
    hitMiss='Hit';
    computerBoard(i,j)='!';
    playerBoard(i,j)='!';
   elseif playerBoard(i,j)~=char(0) 
           hitMiss='Duplicate';
         
   end
   
    
end

    function [gameWon] = isGameWon(computerBoard)
    computerBoardFlat = reshape(computerBoard,[1,64]); %Turns board into a row vector
    computerBoardNoDuplicates = unique(computerBoardFlat); %Unique returns a list with duplicated elements removed
    if (numel(computerBoardNoDuplicates) == 2) && (sum(computerBoardNoDuplicates == '!') == 1) %If there are only empty spaces and no ships left
        gameWon = true;
    else
        gameWon = false;
    end
end

function computerBoard = placeShips()
    computerBoard = char(zeros(8,8)); %Create a blank board
    
    computerBoard = chooseRandomShipLocation(computerBoard,5);
    computerBoard = chooseRandomShipLocation(computerBoard,4);
    computerBoard = chooseRandomShipLocation(computerBoard,3);
    computerBoard = chooseRandomShipLocation(computerBoard,3);
    computerBoard = chooseRandomShipLocation(computerBoard,2);
end

function computerBoard = chooseRandomShipLocation(computerBoard,length)
    %Choose three random numbers
    %First number is a 0 or 1. 0 means place the ship vertically, 1
    %horizontally
    orientation = randi([0 1]);
    %Second number is between 1 and 8 - length + 1, to make sure the ship
    %can fit on the board
    i = randi([1 (8 - length + 1)]);
    %Third number is between 1 and 8, choosing the row or column
    j = randi([1 8]);

    if orientation == 0
        if all((computerBoard(j,i:i+length - 1) == 0))
            %Set the appropriate locations equal to 'S', for Ship
            computerBoard(j,i:i+length - 1) = 'S';
        else
            %If the chosen location is occupied, choose again recursively
            computerBoard = chooseRandomShipLocation(computerBoard,length);
        end
    else
        if all((computerBoard(i:i+length-1,j) == 0))
            %Set the appropriate locations equal to 'S', for Ship
            computerBoard(i:i+length-1,j) = 'S';
        else
            %If the chosen location is occupied, choose again recursively
            computerBoard = chooseRandomShipLocation(computerBoard,length);
        end
    end
end

function [] = displayBoard(pieces)
    fprintf('  1 2 3 4 5 6 7 8 \n');
    fprintf(' +-+-+-+-+-+-+-+-+\n');
    for i = 1:8
        newRow = true;
        for j = 1:8
            if newRow
                fprintf('%s',char('A' + i - 1));
                newRow = false;
            end
            fprintf('|%c',pieces(i,j));
        end
        fprintf('|\n');
        fprintf(' +-+-+-+-+-+-+-+-+\n');
    end
end
