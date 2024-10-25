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
