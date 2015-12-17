%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	SVM Classification program
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja, NISlab
%%	Last rev:			
%%	Comment:			Takes the manual classified entries and runs them through the
%%								learning stage, then takes the remaining dataset and runs
%%								trials on them
%%
%%	Has to be recreated for arbitrary number of databases
%%  pokemon( RESULT(1:52,:), RESULT(53:size(RESULT,1),:), [4,5,6,7,8,9,11] )
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ans = pokemon( RES, LBL, FLDS )
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%		Variables
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ans 			= [];											%Return variable
    ret 			= zeros(1, 100);					%Result for x classification runs
   	good_data = good(:, fields);				%Sets the good_data set
		bad_data  = bad( :, fields);				%Sets the bad_data set
		gSize			= size( good_data, 1 );		%Number of elements in HQ data set
		bSize			= size( bad_data, 1 );		%Number of elements in LQ data set
		dSize			= gSize + bSize;					%Number of elements in comb data set
    N   			= bSize;									%Number of LQ images
    k   			= gSize;									%Amount to use for training
		
    %%%%%%RRRR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%		Initialize datasets for use with SVM classifier
		%%%%RR%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		data	= RES(:, FLDS);							%Complete database of results from main.m
		label	= LBL;											%Man classification from webIIC "G/B"
    species = cellstr( label );      	%Create species
    groups = ismember( species,	'G');	%HQ are 1 and LQ are 0
    cp = classperf( groups );					%
  

		%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%		Perform training and classification
		%%				Uses all HQ images and an equal amount of randomly 
		%%					selected LQ images.
		%%				This is done a 100 times to ensure an adequat dataset
		%%					for data analysis
		%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:1:100
			%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%		Generate data set for training
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			set 	= reshape(randperm(N, k), k, 1) + gSize;	%Create X*1 matrix
      train = logical( zeros( dSize, 1 ) );						%Zero out training set
      train( 1:gSize, 1 ) = logical( 1 );							%Mark HQ for training
      train( set, 1 ) 		= logical( 1 );							%Mark LQ for training

			%PSEUDO
			%set is selection of "bad" images
			%select all from label which is U/G/B 0/1/2
			%set this as training set with logical ones
      
			%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%		Generate data set for testing
			%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      test  = logical( zeros( dSize, 1 ) );						%Zero out testing set
      test(gSize+1:dSize, 1 ) = logical( 1 ); 				%Mark all LQ for testing
      test(  set, 1 ) = logical( 0 );							    %Remove LQ training images
			
			%PSEUDO
			%create zero test set
			%mark all images not marked for training (U or 0) as 1

      
			%%%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%		Train the SVM classifier
			%%			Using the generated training set
			%%%%%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      svmStruct = svmtrain(   data( train , : ) ,         ...
                              groups( train ),           	...
                              'showplot', false,         	...
                              'kernel_function', 'rbf');

			%%%%%%%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%		Classify the data set for testing
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      classes = svmclassify(  svmStruct,                  ...
                              data( test , : ) , 					...
                              'showplot', false);

      ret(1, i) = sum( classes );                    %Sum the classification
    end
    
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%		Generate results to be returned
		%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%RR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y = sum( test  );
    ans = [	min(    ret ),            ... %Worst case
            max(    ret ),            ... %Best case
            median( ret ),            ... %center value
            mode(   ret ),            ... %most common value
            mean(   ret ),            ... %average value
            min(    ret ) * 100 / y,  ... %Worst prop class. as good
        	 	max(    ret ) * 100 / y,  ... %Best prop class. as good
  	        median( ret ) * 100 / y,  ... %Center classified as good
    	      mode(   ret ) * 100 / y,  ... %Common prop class. as good
            mean(   ret ) * 100 / y;  ... %Avg. prop class. as good
      	  ];
end                    
