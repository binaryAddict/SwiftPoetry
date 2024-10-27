# SwiftPoetry

## Purpose

The project is purely an exercise as part of a job interview process. The task is to pick an API I find interesting and make an App, a suggested set of APIs was provided https://github.com/public-apis/public-apis/blob/master/README.md.

## Assumptions

- By API, this means server API to demonstrate standard URL fetching.
- It NEEDS to be testable, but unit tests are a NICE TO HAVE given time limits.
- A JSON viewer App is fine given time, doing something beyond is a NICE TO HAVE.
- The UI code needs to be structurally sound, but good UI/UX is a NICE TO HAVE.

## Project

The App is a Speed Reading app with the data source being Poetry coming from the API https://github.com/thundercomb/poetrydb; which was on the suggestions list.

The App also comes with some content already installed, and saves all content that is fetched to the offline store. This also gives some fallback if the API stops working.

So it ticks one NICE TO HAVE box for doing something beyond a JSON viewer; it is a Speed Reading app and it has offline content.

## Implementation Notes

1. The API does not have paging.
2. I assume the service data is mostly static and have treated it as such. This makes the app simplier but in the real world would need mechanism.
3. I only fetch the Aurthors list once and store it parsed in memory. See 2.
4. Once an Aurthor's poems are stored offline I never refresh it. See 2.
5. If an Aurthor's poems are avalible offline that is what will be used even when not in offline mode. See 2.
6. The API allows the fetching of all Poems from an Author in one call, which I have used for simplicity. This would be a performance worry in the real world, and poems would fetch indvidually or in pages. For most Author's the JSON is less than 100KB. A hand full are in the 1-4 MB range which is large but not as large as the JavaScript fetch for most web pages.
7. When loading author poems from disk everying is loaded. I would maybe better to save the poems idividually and save poem info list without the poem. Given there was no noticable performance issues and since would be more complex I left it.


## Testing notes

- Largest know poems.json - "Lord Byron", just under 4MB. JSON parse time less than 0.05sec on iPhone 12 Pro in DEBUG.
- Longest know poem - "Lord Byron: Don Jaun", 18K+ lines, 120K words, estimate 8+ hours at 240 word per minute. Word count and word parse are both under 0.1 on iPhone 12 Pro in DEBUG.
- Median poem looks under 20 lines ("Lord Byron: Don Jaun" is a 1,000x Median)

On the Poem screen and speed reader screen I did not notice any stutters with "Lord Byron: Don Jaun" when performing Word count and word parse on the main thread when the ViewModels were created.

Word count on the Poem screen is loaded async. Maybe over kill as no stutter issues were noticed but the user would not know how large a poem is before landing on the screen.

On the other hand parsing out the words on the Speed Reader page is done on the main thread. A small stall if it going to take hours to spead read, is not so big an issue here and would be more understandable by a user and I dont think someone would try given no functionality to save progress.

