Object {
	id: numberValidatorObject;

	property int min: 0;
	property int max: 59;

	function validate(number)
	{
		return (number <= numberValidatorObject.max) && (number >= numberValidatorObject.min);
	}
}
