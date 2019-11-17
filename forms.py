from flask_wtf import FlaskForm,
from wtforms import StringField, TextField, SubmitField, IntegerField
from wtforms.validators import DataRequired, Length


class BloodReqForm(FlaskForm):
    """Make requests form."""
    amount = IntegerField('Blood Amount', [
        DataRequired()])
    email = StringField('Blood Type', [
        Email(message=('Not a valid email address.')),
        DataRequired()])
    body = TextField('Message', [
        DataRequired(),
        Length(min=4, message=('Your message is too short.'))])
    
    submit = SubmitField('Submit')

