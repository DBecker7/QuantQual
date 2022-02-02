---
title:
    - Quantitative and Qualitative Analysis
author:
    - Devan Becker
theme:
    - AnnArbor
colortheme:
    - spruce
---

# Introduction

## Land Acknowledgement

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

## About Me

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

## Outline

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

## Before we begin

- Interrupt at any time\newline
- All notes/links/resources are on GitHub\newline
- I have allowed myself **ONE** equation. 

\quad

```
The GitHub version also has my (approximate) script inside 
:::notes::: tags, which show up as text in the pdf.
```

:::notes
I'll add the GitHub link to the chat now, but I'll also have Mihaela send it out after the meeting.
:::


# Regression


## Terminology

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


## Ethics: biosex versus gender

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

## Intro to linear models

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


## A **Mean**ingful intercept

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


## Linear models: slopes

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/3-slope.png}
\end{center}

Next steps:\vspace{-3mm}

:::notes
While the intercept can be modified so that it is meaningful, the slope is almost always meaningful for any analysis.
The value of the slope represents the relationship between the features and the response. 
Most of the time that we're doing a linear regression, this is what we want.
:::

## Binary Features

\centering
Suppose we have a variable that is labelled either 0 or 1. 

What does the slope represent?

:::notes
t-tests are actually just linear regression in disguise!
ANOVA and ANCOVA are too!
:::

## The story so far

- The Intercept is a mathematical necessity
- The Slope answers our questions

But how good is our model?

## The most important part!


\begin{center}
\includegraphics[width=0.8\textwidth]{figs/4-error.png}
\end{center}

- The line will never go through every point perfectly!
- Know where the model fails can tell you everything!

:::notes

:::

## Residual plots: residuals versus predicted

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/5-resid.png}
\end{center}

- A perfect residual plot should show no pattern.
- This plot looks like there's a slight pattern...

## The pattern

Each species has a slightly different relationship!!!

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/6-species.png}
\end{center}

## Putting it all together

1. Get data
    - Data cleaning is the hardest part.
2. Plot data
    - If you haven't plotted it, you're doing it wrong.
3. Fit model
4. Check model
    - If you haven't plotted it, you're doing it wrong.

## Non-linear models?

*illustration:* sine, polynomial, spline smoothing

It's all just linear!

## Feature Selection

This is hard

## Learning Linear Models

0. Start a discovery journalism document
1. A basic introduction to R or Python.
2. A tutorial on data cleaning and visualization
    - Python Data Science Handbook
    - R for Data Science
3. A tutorial on linear models
    - Code everything in your language of choice!
4. Write a self-tutorial

# Machine Learning

## What is Machine Learning?

Statistics, but done by a computer scientist...

OR

Anything that tries to get information from data!

\quad

This includes linear regression!

:::notes
There are tons opinions on what counts as machine learning
Most definitions have some variation on "getting information from data", but each definition will have different caveats or inclusions.

:::
 

## Regression in Machine Learning

- **Lasso Regression**
    - It's like linear regression, but it automatically removes features.
    - Related: Ridge regression, ElasticNet
- **xgBoost**
    - Remember the residual plots? What if we fit a regression to those residuals?
- **Neural Nets**
    - ...


## Neural Nets 


# Classification

## Binary Target


*Illustratio:* pengtoo (once I can use my mouse again.)

:::notes
Let's return to the penguins data set.
The original study intended to quantify the sexual dimorphism, so let's focus on that.
In this case, the biosex is either male or female - it can only be one of these two things, which is why it's called binary.
It may seem strange to try and predict the biosex of the penguins since that's something we can fairly easily check, but by knowing what factors make better predictions we can learn a lot about the biological, sociological, and environmental factors affecting penguins.
:::

## Choosing between two options

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/7-SVM.png}
\end{center}

- When Flipper Length is below 198, most are female.
- This is called SVM, or Support Vector Machines

## More dimensions!

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/8-SVM2.png}
\end{center}

- With more information we can fit a better model!
- ...

## ... but there's a reason I only used Gentoo

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/9-SVM3.png}
\end{center}

## Three categories: Species

\begin{center}
\includegraphics[width=0.8\textwidth]{figs/10-SVM4.png}
\end{center}
