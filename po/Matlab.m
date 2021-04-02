channelID = 906882;

% Enter the trigger url from IFTTT.  It will have the form:
%. https://www/maker/com/trigger/<path>/with/key/<ITFFF API key>
iftttURL = 'https://maker.ifttt.com/trigger/bodyPosture/with/key/mBCFXFiMfc-_x3zCD2cVz3gbzsgmo75AD6NWZj8XDGN';
% Channel Read API Key (if you are using your own moisture channel)
% If your channel is private, then enter the read API Key between the '' below:
readAPIKey = 'YO7BICPM40MHPSOV';

% Read the last two weeks of moisture data from ThingSpeak.
postureData = thingSpeakRead(channelID,'NumDays',14,'Fields',1,'ReadKey',readAPIKey);

% Calculate the threshold from the recent data.
span=max(postureData)-min(postureData);
poorPosture = 0.1*span+min(postureData);

% Build the ThingSpeak URL.
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(channelID),'/fields/1/last.txt');

% GET the data from ThingSpeak.
lastValue = str2double(webread(thingSpeakURL, 'api_key', readAPIKey));

if (lastValue<poorPosture)
    postureMessage = ' Bad Posture Detected! ';
    webwrite(iftttURL,'value1',lastValue,'value2',postureMessage);
end

if (lastValue>poorPosture)
    postureMessage = ' Normal Posture ';
    webwrite(iftttURL,'value1',lastValue,'value2',postureMessage);
end