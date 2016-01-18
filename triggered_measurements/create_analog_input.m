function [ ai, ai_channel_setting ] = create_analog_input( settings )
%receives settings struct from daq_parameters...m and provides an analog
%input object
%
%   Analog input object created with settings provided by parameter
%   function. The object is configured and ready to implement.
%   ai_channel_settings gives detailed information about analog input
%   configuration.
%
%   Includes addition of runtrigger callback function, executed/called back
%   when triggered by TTL.
%
%
%   (c) 2016, Simon Lansbergen.
%

% Create Analog Input Object
ai = analoginput(settings.daq_type,settings.daq_hw_id);

% Setup Analog Input Object
required_samples = floor(settings.sample_rate * settings.duration);

if settings.samples_per_trigger == false
    set(ai, 'SamplesPerTrigger', required_samples);
else
    set(ai, 'SamplesPerTrigger', settings.samples_per_trigger);
end

set(ai, 'SampleRate', settings.sample_rate);

set(ai, 'TriggerType', settings.trigger_type);

if settings.trigger_type == 'HwDigital'
    set(ai, 'TriggerCondition', settings.trigger_cond);
    if settings.trigger_repeat ~= false
        set(ai, 'TriggerRepeat', settings.trigger_repeat);
    end
end


% Add channels to Analog Input Object
ai_channel_setting = addchannel(ai,settings.hwchannels,settings.hwnames);

% add run_trigger callback function, executed when triggered by TTL pulse
set(ai, 'TriggerFcn', {@run_trigger,settings});


end

