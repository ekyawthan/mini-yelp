import turicreate as tc


# Load data
data = tc.SFrame('yelp-data.csv')

# Create a model
model = tc.text_classifier.create(data, 'stars', features=['text'], max_iterations = 20)

# Make predictions & evaluation the model
predictions = model.predict(data)
results = model.evaluate(data)

# Save the model for later use in Turi Create
model.save('MyTextClassifier.model')

# Export for use in Core ML
model.export_coreml('MySentenceClassifier.mlmodel')
