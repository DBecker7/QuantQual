---
title:
    - Quantitative and Qualitative Analysis
subtitle: "What's out there and what you need to know."
author:
    - "Devan Becker\\newline Public Health Agency of Canada; National Microbiology Laboratory\\newline\\newline February 7th, 2022\\newline For Western Postdoctoral Scholars"
theme:
    - Dresden
colortheme:
    - Western2
---


# Introduction

### Land Acknowledgement

<!---
TODO: 
    - Sentence case for all titles
    - Better resolution neural net plot?
    - Fix the "Error" plot
    - Plot of the data *before* I start modelling.
--->

UWO exists on the traditional territories of:

- Anishinaabek
- Haudenosaunee
- Lūnaapéewak
- Chonnonton

These lands are connected with the London Township and Sombra Treaties of 1796 and the Dish with One Spoon Covenant Wampum.



:::notes
I acknowledge that Western University is located on the traditional territories of the Anishinaabek, Haudenosaunee, Lūnaapéewak, and Chonnonton Nations, on lands connected with the London Township and Sombra Treaties of 1796 and the Dish with One Spoon Covenant Wampum. 
The Dish with One Spoon is a metaphor for the responsibilities that we have when sharing the land; each of us eats from the same bowl and we must always leave enough for the others. 
It's easy for people like me to think of history books when talking about indigenous peoples, but I recognize that they are contemporary stewards of the land and vital contributors of our society. 
I also recognize the great diversity among indigenous peoples, both within and between nations. 
For instance, the Dish With One Spoon Covenant Wampum is not an "Indigenous Thing", it's specific to the Haudenosaunee peoples.
:::

### About Me

- Education
    - B.Sc. Math (Laurier)
    - M.Sc. Stats/Biostats
    - Ph.D. Stats\newline
- Work
    - Postdoc - SARS-CoV-2 in wastewater
    - Public Health Agency of Canada\newline
- Life
    - Music, reading, outdoorsy stuff
    - Crying about the housing market

:::notes
A little about me before we begin. 
Did an undergrad thesis project with Doug Woolford.
He introduced me to some people at Western for my master's, then followed me and became my PhD supervisor
I defended my PhD thesis exactly one week before the pandemic hit Canada, so I am extremely lucky that I got hired as a Postdoc in the Schulich school.
Outside of academia, I listen to and play music (poorly), go camping, hiking, showshoeing, kayaking, and rock climbing, and I like to read a variety of things.
:::

## Foreshadowing

### Outline

- **Quantitative:** Dealing with numbers
    - Any number in a range
    - Only 0's and 1's (maybe a 2)
    - Things we can turn into numbers\newline
- **Qualitative:** Dealing with descriptions
    - Using your brain
    - Using your computer\newline
- **Meditative:** Dealing with everything
    - How to get started
    - Accessing resources
    - Not being afraid of coding

:::notes
I'm a statistician by training, so most of this will be spend on quantitative analysis.
I'm going to focus on linear regression, which is an analysis technique that can be used when you're modelling something that could take any value in a range.
I'll briefly go over a few other techniques that work for numbers in a range.
I'll also talk about classification problems, which is when the thing we're modelling can only be one of a handful of numbers.
I'll talk about qualitative analysis, but mostly from a data scientist's perspective.
Finally, I'll do my best to get you started on learning your own analysis, and hopefully convince you that all this isn't that scary.
There are lots of resources on campus and across the internet, but there are some caveats with all of those.
:::

### Before we begin

- Interrupt at any time\newline
- All notes/links/resources are on GitHub\newline
- Ask future questions in the PAW Slack chat\newline
- I have allowed myself **ONE** equation. 

\quad

```
The GitHub version also has my (approximate) script inside 
:::notes::: tags, which show up as text in the pdf.
```

:::notes
I'll add the GitHub link to the chat now, but I'll also have Mihaela send it out after the meeting.
:::

### What to watch for

Keep an eye out for the following concepts:

1. Garbage In, Garbage Out (GIGO)
2. Numerical summaries lie - you need plots!
3. Models are models.
4. Models are wrong.

:::notes
No matter what kind of analysis you are doing, there are some things in common.
First is GIGO - your data limit what you can do with your model.
Second, looking at numbers alone will only tell you part of the story.
Get in the habit of plotting everything you come across.
Third is the tautology that all models are models.
In most software, spending time learning how one model works will help you understand many other different models.
For instance, linear models and neural networks have almost the same syntax in R.
Finally, come to terms with the fact that any analysis you do will be imperfect.
The most important part of any modelling endeavour is being humble about the results and acknowledging where and why it deviates from the truth.
:::

# Regression

### Linear Models

:::notes
So let's start with the fun one - regression!
Every discipline uses their own terminology, so we'll get that out of the way first.
The variable that we're trying to model is called the **target**.
You may know this as the dependent variable or the response.
Whatever you call it, this is generally what we're trying to make predictions for and usually shows up on the y axis.
The features are the information we're trying to incorporate into our model to better predict the target.
You may know them as explanatory or independent variables, or maybe as IVs.
:::


- The **Target** could be any number in a range.
    - A.k.a. dependent variable or response.
- The Features could be any data type
    - A.k.a. explantory or independent variables (IVs)

:::notes
For this example, we're going to use the Palmer Penguins dataset, which was collected at Palmer station in antarctica. 
We have their body mass (in grams), which is going to be our target variable.
We're trying to determine if penguins are getting better nutrition and/or less competition on different islands.
We also know their bill length (mm) and their flipper length (mm). These penguins are one of three species, are found on one of three islands (with some overlap) and are either male or female. 

Note to people reading the pdf: the data are from https://allisonhorst.github.io/palmerpenguins/ and all my analyses are done in R.
:::

| **mass**   | bill_len      | flipper_len      |species   |island    |sex    |
|-----------:|--------------:|-----------------:|:---------|:---------|:------|
|        3750|           39.1|               181|Adelie    |Torgersen |male   |
|        3800|           35.3|               187|Adelie    |Biscoe    |female |
|        4150|           42.0|               210|Gentoo    |Biscoe    |female |
|        5350|           48.7|               222|Gentoo    |Biscoe    |male   |
|        3725|           52.7|               197|Chinstrap |Dream     |male   |
|        3750|           51.3|               197|Chinstrap |Dream     |male   |
|        3400|           50.1|               190|Chinstrap |Dream     |female |



### Intro to linear models

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/1-intro.png}
\end{center}

- Find the slope and intercept to best fit the cloud of points.
    - Slope: rise over run.
    - Intercept: the body mass when flipper length is 0.

:::notes
The main goal of linear regression is to find the slope and the intercept that best fit a cloud of points.
In this plot, the slope represents how much the body mass increases with flipper length.
Generally, this is what we want from a regression - how does the target change with the features?
The intercept represents the weight of the penguin when the flipper length is 0.
Don't think too much about that - the intercept is just a mathematical requirement for building a line.
:::


### A **Mean**ingful intercept

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/2-center.png}
\end{center}

- Subtract the average flipper length from each individual flipper length.
    - The intercept is the body mass at the average flipper length!
    - This also helps with the underlying math.

:::notes
The intercept can, however, be made to be meaningful. 
If you subtract the mean value from each of the values of the feature, then "0" is the new mean value!
Now the intercept is the value of the target at the average value of the response.
:::


### Linear models: slopes

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/3-slope.png}
\end{center}

:::notes
While the intercept can be modified so that it is meaningful, the slope is almost always meaningful for any analysis.
The value of the slope represents the relationship between the features and the response. 
Most of the time that we're doing a linear regression, this is what we want to quantify.
:::

### A **SD**ingful slope

*illustration:* scaling the x values

- Subtract mean flipper length from each individual flipper length
- Divide by the standard deviation. 

This is called **scaling** the feature.

:::notes
Similar to a **meaning**ingful intercerpt, we have an **SD**ingful slope.
Recall that the slope represents the increase in the target for a one unit increase in the feature.
When we divide the feature by the standard deviation before the modelling step, we make it so one unit represents one standard deviation.
Becaues of this, the slopes of different features can easily be compared!
When we mean-center and divide by the standard deviation, we call that "scaling".
For some machine learning techniques, this is absolutely necessary.
:::

### Binary Features

\centering
Suppose we have a variable that is labelled either 0 or 1. 

What does the slope represent?

:::notes
The slope represents the change in the target for each one unit increase in the feature.
Binary features only have one unit in between, so the increase in the target is the difference in the centres of the two groups.
This means that t-tests are actually just linear regression in disguise!
There's a difference in the variance calculation, but the underlying machinery works the same.
As a side note, ANOVA and ANCOVA are also secretly linear models.
In fact, fitting ANOVA in R involves fitting a linear model.
:::

### The story so far

- The Intercept is a mathematical necessity\newline
- The Slope answers our questions

\quad

But how good is our model?

:::notes
Computers are really smart, but they're also really dumb.
A computer will calculate the intercept and the slope for any data you throw at it - regardless of whether it's a good idea!
There are many cases where linear models are not appropriate - such as when the target is categorical - but the computer computes anyway.
That's why they call it a computer and not a thinker!
Even if a linear model is appropriate, it doesn't mean your results will be good.
:::

### The most important part!


\begin{center}
\includegraphics[width=0.8\textwidth]{figs/4-error.png}
\end{center}

- The line will never go through every point perfectly!
- Know where the model fails can tell you everything!

:::notes
When we fit a line, we can find the estimated value simply by looking at the height of the line.
It would be extremely surprising if the line always hit every point!
Instead, there's always going to be some measure of error. 
Understanding these errors is the most important part of any modelling challenge - no matter what type of model you're using.
Later, we'll see some models that use words as their input.
Even with these models, knowing about the errors is the most important part!
:::

### Residual plots: residuals versus predicted

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/5-resid.png}
\end{center}

- A perfect residual plot should show no pattern.
- This plot looks like there's a slight pattern...

:::notes
Rather than fitting every point, a perfect model is one that's wrong consistently.
That is, the estimated values are not systematically different from the truth.
This problem can happen when you have a pattern in the residuals, and the best way to do this is with a residual plot.

The residual plot shows the errors on the y axis and the estimated values on the x axis.
This may seem a bit strange; most people would expect to plot the errors against the features.
We do it this way for two reasons:

1. If there are a lot of features, it becomes very tedious to check every plot.
2. There might be complicated interactions between features that are hard to see without considering many features.
:::

### The pattern

Each species has a slightly different relationship!!!

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/6-species.png}
\end{center}

:::notes
Here's the problem: there are three different species of penguins, each with different physiology.
For this application, we'd need to account for these differences in species.
At this point, it's worth working through a textbook or a course on linear models. 
:::

### Putting it all together

1. Get data
    - Data cleaning is the hardest part.\newline
2. Plot data
    - If you haven't plotted it, you're doing it wrong.\newline
3. Fit model\newline
4. Check model
    - If you haven't plotted it, you're doing it wrong.

:::notes
Let's take a minute and look at what we've done so far.
We started with some good clean data, but this is rarely an easy step.
In fact, cleaing data is frequently the most time consuming part of an analysis!
Furthermore, the quality of the data determines what you can say about the target. 
We plotted the data and saw that our assumed model form looks more-or-less appropriate, so we went ahead and fit a model.
You might notice that I didn't talk too much about actually fitting the model.
This is because that step is quite easy once you're comfortable with the software that you use.
The hard part is making sure that the model you fit is the model that you want.
In this example, I have a long way to go!
:::

### Non-linear models?

*illustration:* sine, polynomial, spline smoothing

These are all just linear!

### Feature Selection

- Including all of your features can be bad.
    - Correlated features
    - Model complexity
    - Variance inflation\newline
- Instead, only choose the important ones.

Advice: plot everything, model what you think is correlated, check your results.

:::notes
When I talk about making sure your model has the best errors, I'm speaking in reference to models with different features.
For instance, in this example I had both bill length and bill depth.
These two features are measuring very similar things, and including both in a model may actually make you less able to describe the releationship with body mass.
It also makes the model more complex, and a simpler model is better for interpretation.
When two features are highly correlated, the model can't tell which one is better to use.
This raises the variance of the slope terms, which makes it hard to make new predictions.

The best course of action is to look at a bunch of plots and take notes.
If bill length and bill depth are correlated, but bill length is less correlated with the other feature, then maybe that's the one you should us in the model.
If there is correlation between features, such as the flipper length being different for different species, include this in your model!
Go through all of the features, their interactions with each other, and their interactions with the target, then write down a relationship that you think describes the target.
Fit that model, and then start tinkering with other possible model formulations.
:::


### Learning Linear Models

0. Start a discovery journalism document\newline
1. A basic introduction to R or Python.
    - NO COPY/PASTING\newline
2. A tutorial on data cleaning and visualization
    - Python Data Science Handbook
    - R for Data Science\newline
3. A (non-code) tutorial on linear models
    - Code everything in your language of choice!\newline
4. Write a self-tutorial

:::notes
We're going to end our discussion of linear models there, even though there's plenty more to learn.
This slide has some suggestions for continuing your journey.
Especially for self-directed learning, I strongly encourage you to practice Discovery Journalism.
Each time you learn something new, write up a description for yourself as if you're the first person to discover it.
Work through a basic coding tutorial, but make sure that you never ever copy and paste code.
It's easy to read a semi colon and move on, but was that actually a semi colon or was it just a regular ol' colon? 
By typing it out and trying to run it, you have to pay attention to these things.

Before getting into linear models, do a basic course on data cleaning and visualization. 
This doesn't have to be a big one, it might only even take an hour or two.
Of course, split this into 15-30 minute chunks where you start by reviewing your previous notes.

Then you can work through a non-code tutorial for linear modelling.
It doesn't have to be non-code *per se*, but this forces you to code it yourself and get a better perspective.

Finally, summarise your knowledge.
I'd suggest making it as a GitHub repository so that others can benefit from your notes and you'll have access it wherever you're working.
:::

## Machine Learning

### What is Machine Learning?

- Statistics, but done by a computer scientist...

\quad\quad\quad\quad\quad\quad\quad\quad\quad\quad --OR--

- Anything that tries to get information from data!

\quad

This includes linear regression!

:::notes
There are tons opinions on what counts as machine learning.
Most definitions have some variation on "getting information from data", but each definition will have different caveats or inclusions.

To help you understand what machine leaning actually is, think back to linear models.
When you tell your computer to calculate the slope, that counts as the "machine" "learning" what the slope is based on data.
Artificial Intelligence is the process of a machine learning how to think like a human, but even in this case the learning part simply means calculating things from input data.

For this workshop, I'll talk briefly about a few common techniques and then do a bit of a deeper dive into neural networks.
Trust me, they're not that scary.
:::
 

### Regression in Machine Learning

- **Lasso Regression**
    - It's like linear regression, but it automatically removes features.
    - Related: Ridge regression, ElasticNet\newline
- **xgBoost**
    - Remember the residual plots? What if we fit a regression to those residuals?\newline
- **Neural Nets**
    - ...

:::notes
The first example of machine learning is called LASSO regression.
In the linear regression section, we saw that variable selection is hard.
Lasso does it for you!

Another issue we had in linear regression was the problem of residuals still being correlated with one of the features.
xgBoost does this for you!

There are many other types of machine learning that aren't regression, and we'll cover those in the sections on Classification and Qualitative analysis.
For now, let's dive into neural networks.
:::

### Neural Nets 

- What most people think of as ML.
    - Deep Learning: fancy neural nets.\newline
- Loosely based on the way synapses work.\newline
- Just a bunch of linear regressions

:::notes
When most people think of machine learning, they're thinking about neural nets.
They see them as a computer having a brain, which is kinda true (but not really).
They are inspired by a simplified version of how brains pass information, but a completely disconnected from the way brains learn and think.
People also think of them as being hopelessly complex black boxes, but they're actually just a bunch of linear regressions taped together.
:::

### Neural Net Setup

\begin{center}
\includegraphics[width=\textwidth]{figs/NN.png}
\end{center}

- Each node is a linear model
- The target node tells hidden nodes how they were wrong
    - "Backpropagation"; recurrent neural network
- Have to choose number of layers and nodes

:::notes
So here's a computer brain.
There are som inputs, in this case the flipper length and the bill length, and these feed into something called a hidden layer.
Basically, these try and combine all of the features in a way that extracts more information about them.
To predict the target, the information from the hidden layer is combined.

So why do I call this a linear model? 
Let's just look at the target.
The information is "combined" to predict the target.
How is it combined?
With a linear model!
Each of the "nodes" in the hidden layer is a function that takes in values from all previous nodes and spits out a new value, and these values act as the features.
The numbers on the line are just the slopes of a linear model, and the blue "1" is the intercept term.
If you learn more about neural networks, you'll learn that these are called loadings and the bias, but that's not important right now.

So the difficult question now is: how do we determine the way this hidden layer works?
Each time we try and make a prediction, we're wrong by a certain amount.
The target node reports back to all the hidden nodes to tell them them how and why it was wrong, and the hidden nodes adjust their values appropriately.
The hidden nodes generally start at a random number and then try and adjust that number to one that would have reduced the error in the prediction.
This particular formulation is called a recurrent neural network because of the way the error is propagated backwards through the network.

Choosing the number of nodes in a hidden layer is a challenge, and it's possible to have any number of hidden layers!
Just like with linear models, we are stuck trying to decide on a model form.
:::

### Linear Models Versus Neural Nets

- LM requires feature seletion
- NN requires a choice of layers\newline
- LM requires conitnuous data
    - Logistic Regression works, though!
- NN works with any data type
    - Everything must be *scaled*\newline
- LM gives interpretable sloeps
- NN accounts for complex interactions\newline
- LM is better for inference
- NN is better for prediction


### Is NN always better than LM?

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/NNLM.png}
\end{center}

No.


### ML and Ethics

- ML finds patterns that exist
    - It perpetuates existing patterns\newline
- ML is hard to audit
    - Is it just looking at peoples' race? Hard to say!
    - Explainable AI (XAI)\newline
- ML doesn't answer email
    - Why did it make a certain decision?
    - Ca't plead your case.

\url{https://delphi.allenai.org/?a1=Using+AI+to+determine+ethics}

# Classification

### Binary Target


| mass       | bill_len      | flipper_len      |species |island |**sex**|
|-----------:|--------------:|-----------------:|:-------|:------|:------|
|        4500|           46.1|               211|Gentoo  |Biscoe |female |
|        5150|           46.8|               215|Gentoo  |Biscoe |male   |
|        4600|           48.2|               210|Gentoo  |Biscoe |female |
|        5400|           48.4|               220|Gentoo  |Biscoe |male   |
|        4200|           45.5|               210|Gentoo  |Biscoe |female |
|        5550|           50.4|               224|Gentoo  |Biscoe |male   |

:::notes
Let's return to the penguins data set.
The original study intended to quantify the sexual dimorphism, so let's focus on that.
In this case, the biosex is either male or female - it can only be one of these two things, which is why it's called binary.
It may seem strange to try and predict the biosex of the penguins since that's something we can fairly easily check, but by knowing what factors make better predictions we can learn a lot about the biological, sociological, and environmental factors affecting penguins.
:::


### Ethics: biosex versus gender

- Chinstrap penguins have a higher-than-average occurence of homosexual behaviour.
    - Tufts University, Feb 2021: "What’s With All the Gay Penguins?"\newline
- Gentoo penguins have less rigid gender roles.
    - NBC news, Sept 2019: "Gay penguins at London aquarium are raising 'genderless' chick"\newline
- Adelie penguins of any gender all want to be like Adele
    - \<Citation Needed\>


\quad

Always be aware that "biosex" is an imperfect measurement of gender roles.

:::notes
In any analysis, you'll likely run into ethical challenges.
These are penguins, but that doesn't mean that the difference between biosex and gender isn't present.
Understanding the data collection is paramount to a good analysis, and poor interpretations can lead to ethical quandries.
:::

### Choosing between two options

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/7-SVM.png}
\end{center}

- When Flipper Length is below 198, most are female.
- This is called SVM, or Support Vector Machines

:::notes
Let's start with a simple model where we only use flipper length to try and guess the penguins' biosex.
In this plot, I've separated the data into male and female and I added a vertical line at a flipper length of 198.
For this model, we're just going to guess any penguin with a longer flipper than 198 is likely female.
:::

### But how were we wrong?

If we label any penguin with Flipper $<$ 198 as female:

|       | Flipper $<$ 198| Flipper $\ge$ 198|
|:------|-----:|----:|
|Male   |    74|   94|
|Female |    97|   68|

- Many different metrics to calculate!
    - When we label them female, they're actually female 97/(74+97)=56\% of the time.
    - When they're actually female, we label them female 97/(68+97)=58\% of the time.
- This is a **Confusion Matrix**.

See also: sensitivity, specificity, precision, recall, F1 score.


### More dimensions!

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/8-SVM2.png}
\end{center}

- With more information we can fit a better model!
- ...

### ... but there's a reason I only used Gentoo

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/9-SVM3.png}
\end{center}

### Three categories: Species

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/10-SVM4.png}
\end{center}

### It doesn't need to be linear!

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/11-SVM5.png}
\end{center}

### Other Classification Models

- Logistic Regression
    - Basically, LM for probabilities
    - For multiclass, Multinomal Regression\newline
- **Decision Trees** and **Random Forests**
    - A very important model that I'm not covering
    - Still a linear model at heart\newline
- Naive Bayes Classifiers\newline
- K-Nearest Neighbours (KNN)


## Unsupervised Learning

### Definition

In classification, we're predicting labels *and checking if we're right.*

\quad

Unsupervised learning means *we don't know the labels*.

### K-means Clustering

*Illustration:* Unlabelled plot

- Pretend that Species info is *NOT* available.
- How many clusters are there?



# Dimension Reduction

### Motivation

Why use many features when few features do trick?

\quad

By combining features, we might:

- Find out which features have similar effects on the target.\newline
- Find clusters

### Principal Components Analysis (PCA)

A *Principle Component* is a combination of the features (NOT target).

Each component is unrelated to the others.

\begin{align*}
PC1 &= 0.55*bill\_length - 0.51*bill\_depth + 0.65*flipper\_length\\
PC2 &= -0.65*bill\_length - 0.75*bill\_depth - 0.03*flipper\_length\\
...&
\end{align*}

### Principle Components - clustering

\begin{center}
\includegraphics[width=\textwidth]{figs/12-PCA.png}
\end{center}

# Qualitative Analysis

### Qualitative Data

Quality: the properties/characteristics of a thing (not numbers)

- Survey responses 
    - "A lot of people seem to talk about painful things ..."\newline
- Categories
    - "Registered democrats tend to have these qualities ..."\newline
- Texts
    - "The grammar in this act is different from Shakespeare's usual style ..."\newline
- Concepts
    - "These documents could be categorized by their use of ..."

### Qualitative Data **Analysis**

- Fully manual: read everything, pay attention, take notes, compare.
    - I can't help you with this.\newline
- Some computer: search within documents, word clouds, etc.
    - Audio/image/video transcription via neural networks\newline
- Much computer: **Natural Language Processing**
    - It's machine learning, but for words!

## Natural Language Processing

### Code is perfect and English is awful

- It's cold outside, yes?
- It's cold outside, no?

Sometimes, yes and no mean the same thing.

\quad

How the heck does a computer have a chance?!?

### TF-IDF: Who wrote the Op-Ed?
<!---
\begin{center}
\includegraphics[width=0.8\textwidth]{figs/tfidf.png}
\end{center}
--->
\small
Source: \url{http://varianceexplained.org/r/op-ed-text-analysis/}

### Sentiment Analysis: Trump Uses an Android
<!---
\begin{center}
\includegraphics[width=0.75\textwidth]{figs/sentiment.png}
\end{center}
--->
\small
Source: \url{http://varianceexplained.org/r/trump-tweets/}

### More Advanced Natural Language Processing

- Parts of Speech
    - Nouns, verbs, etc.\newline
- Topic modelling
    - Words show up in similar sentences\newline
- Bag of Words (Word2Vec)
    - How often are words used together?\newline

\quad

All of the above can be based on Nueral Nets!




# Meditative



### Summary

1. GIGO
2. Plot everything
3. Learn to code
4. Plot everything

### Learning Path

- Take notes on a basic coding tutorial\newline
- Work through an *easy* passion project
    - Visualize olympic medals (Kaggle)
    - Basic linear model for bitcoin values
- Backpropagate your new knowledge\newline
- Write a tutorial for yourself, share it on GitHub.\newline
- Search Twitter, follow relevant topics/people

### Important things we didn't cover

- **Data Cleaning** (don't use Excel)\newline
- Inference versus Prediction\newline
- Version control and best practices (GitHub!)\newline
- Scrutinizing data\newline

### R versus Python versus Other

- R is stats focused
    - Python has cutting edge machine learning and general purpose\newline
- R has `dplyr` and `ggplot2`
    - Python teaches/requires better coding skills\newline
- RMarkdown is astounding
    - Black holes were imaged in Jupyter\newline
- Both will work for any analysis
    - Use what your colleagues use

FWIW, I used R for this workshop and code is available.










